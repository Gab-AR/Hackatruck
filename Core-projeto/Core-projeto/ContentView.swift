import CoreML
import Vision
import SwiftUI

struct ContentView: View {
    
    @State private var selectedImage: UIImage? = UIImage(named: "gabriel")
    @State private var classificationLabel: String = ""
    
    func classifyImage() {

        guard let uiImage = selectedImage,
              let ciImage = CIImage(image: uiImage) else {
            DispatchQueue.main.async {
                classificationLabel = "Erro ao converter imagem"
            }
            return
        }

        do {
            let model = try VNCoreMLModel(
                for: MobileNetV2(configuration: MLModelConfiguration()).model
            )

            let request = VNCoreMLRequest(model: model) { request, error in
                if let results = request.results as? [VNClassificationObservation],
                   let topResult = results.first {
                    DispatchQueue.main.async {
                        classificationLabel = "Identificado: \(topResult.identifier) (\(String(format: "%.2f", topResult.confidence * 100))%)"
                    }
                } else {
                    DispatchQueue.main.async {
                        classificationLabel = "Nenhum resultado encontrado"
                    }
                }
            }

            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            DispatchQueue.global().async {
                do {
                    try handler.perform([request])
                } catch {
                    DispatchQueue.main.async {
                        classificationLabel = "Erro na classificação: \(error.localizedDescription)"
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                classificationLabel = "Falha ao carregar modelo ML"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Classificador de imagens")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 16)

            Group {
                if let uiImage = selectedImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 260)
                        .cornerRadius(12)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .font(.system(size: 48))
                                .foregroundStyle(.secondary)
                            Text("Nenhuma imagem selecionada")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                    }
                    .frame(height: 260)
                }
            }
            .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 8) {
                Text("Resultado")
                    .font(.headline)
                Text(classificationLabel.isEmpty ? "Toque em “Analisar imagem” para começar." : classificationLabel)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()

            Button(action: {
                classifyImage()
            }) {
                Text("Analisar imagem")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
