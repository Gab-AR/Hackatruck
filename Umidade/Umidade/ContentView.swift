import SwiftUI
import Foundation
import Combine
import Charts

class SensorViewModel: ObservableObject {

    @Published var umidade = 0
    @Published var historico: [HumiditySample] = []

    private var webSocketTask: URLSessionWebSocketTask?

    var humidityPercent: Int {
        percent(from: umidade)
    }

    func conectar() {
        let url = URL(string: "ws://192.168.128.105:81")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receber()
    }

    private func receber() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let texto):
                    if let data = texto.data(using: .utf8),
                       let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        DispatchQueue.main.async {
                            guard let self = self else { return }
                            self.umidade = json["umidade"] as? Int ?? 0

                            let p = self.humidityPercent
                            self.historico.append(HumiditySample(date: Date(), percent: p))

                            if self.historico.count > 120 {
                                self.historico.removeFirst(self.historico.count - 120)
                            }
                        }
                    }
                default:
                    break
                }
            case .failure(let erro):
                print(erro)
            }
            self?.receber()
        }
    }

    private func percent(from raw: Int) -> Int {
        let clamped = max(0, min(1024, raw))
        let inverted = 1024 - clamped
        let percent = Int((Double(inverted) / 1024.0) * 100.0)
        return max(0, min(100, percent))
    }
}

struct HumiditySample: Identifiable {
    let id = UUID()
    let date: Date
    let percent: Int
}

struct ContentView: View {
    @StateObject private var viewModel = SensorViewModel()
    @State private var showChart = false

    private var humidityProgress: Double {
        Double(viewModel.humidityPercent) / 100.0
    }

    private var imageName: String {
        viewModel.humidityPercent < 50 ? "seco" : "molhado"
    }

    var body: some View {
        VStack(spacing: 24) {
            // Imagem de estado (seco/molhado)
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 160)
                .padding(.top, 24)

            // Percentual grande
            Text("\(viewModel.humidityPercent)%")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()

            // Barra de progressão estilo "reservatório"
            VStack(alignment: .center, spacing: 12) {
                Text("Umidade")
                    .font(.headline)

                WaterLevelView(progress: humidityProgress)
                    .frame(width: 160, height: 160)
            }

            // Botão para abrir o gráfico (Charts)
            Button {
                showChart = true
            } label: {
                Image(systemName: "chart.xyaxis.line")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.orange)
                    )
            }
            .accessibilityLabel("Mostrar gráfico de umidade")
            .sheet(isPresented: $showChart) {
                ChartScreen(viewModel: viewModel)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.conectar()
        }
    }
}

// Barra personalizada que enche de baixo para cima
struct WaterLevelView: View {
    var progress: Double // 0.0 ... 1.0

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                // Fundo transparente apenas para manter o shape
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.clear)

                // Nível de água
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: max(0, min(1, progress)) * geo.size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.black.opacity(0.6), lineWidth: 3)
            )
            .animation(.easeInOut(duration: 0.35), value: progress)
        }
    }
}

// Tela do gráfico usando Charts
struct ChartScreen: View {
    @ObservedObject var viewModel: SensorViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Chart(viewModel.historico) { sample in
                    AreaMark(
                        x: .value("Tempo", sample.date),
                        y: .value("Umidade (%)", sample.percent)
                    )
                    .foregroundStyle(LinearGradient(
                        colors: [Color.blue.opacity(0.4), Color.blue.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom)
                    )

                    LineMark(
                        x: .value("Tempo", sample.date),
                        y: .value("Umidade (%)", sample.percent)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.blue)
                    .lineStyle(.init(lineWidth: 3))
                }
                .chartYScale(domain: 0...100)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5))
                }
                .chartYAxis {
                    AxisMarks(values: .stride(by: 20))
                }
                .padding()
            }
            .navigationTitle("Umidade (%)")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fechar") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
