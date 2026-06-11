import SwiftUI
import PhotosUI
import Vision
import AVFoundation

struct ContentView: View {
    @State private var photoPicked: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var recognizedText: String = ""
    @State private var isRecognizing: Bool = false
    @State private var isSpeaking: Bool = false
    @State private var errorMessage: String?

    private let speechSynth = AVSpeechSynthesizer()
    @State private var speechDelegate: SpeechDelegate?

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("StudyCast")
                    .font(.largeTitle).bold()
                    .padding(.top)

                Group {
                    if let selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 260)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .shadow(radius: 4)
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.12))
                            VStack(spacing: 8) {
                                Image(systemName: "photo")
                                    .font(.system(size: 40, weight: .light))
                                    .foregroundStyle(.secondary)
                                Text("Nenhuma imagem selecionada")
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                            }
                        }
                        .frame(height: 220)
                        .padding(.horizontal)
                    }
                }

                VStack(spacing: 12) {
                    Button {
                        Task { await analyzeCurrentImage() }
                    } label: {
                        Text(isRecognizing ? "Analisando..." : "Analisar Texto")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.indigo)
                            .foregroundStyle(.white)
                            .cornerRadius(25)
                    }
                    .disabled(selectedImage == nil || isRecognizing)

                    Button {
                        toggleSpeech()
                    } label: {
                        Text(isSpeaking ? "Parar Leitura" : "Escutar Texto")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.85))
                            .foregroundStyle(.white)
                            .cornerRadius(25)
                    }
                    .disabled(recognizedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                    PhotosPicker(selection: $photoPicked, matching: .images, photoLibrary: .shared()) {
                        Text("Pegar da Galeria")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.indigo)
                            .foregroundStyle(.white)
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal)

                ScrollView {
                    Text(recognizedText.isEmpty ? "O texto reconhecido aparecerá aqui." : recognizedText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .foregroundStyle(recognizedText.isEmpty ? .secondary : .primary)
                }
                .background(Color.gray.opacity(0.08))
                .cornerRadius(12)
                .padding(.horizontal)

                Spacer(minLength: 12)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: photoPicked) { _, newValue in
            Task { await loadPickedImage(newValue) }
        }
        .onAppear {
            // Cria e mantém referência forte ao delegate
            let delegate = SpeechDelegate(isSpeaking: $isSpeaking)
            self.speechDelegate = delegate
            self.speechSynth.delegate = delegate
        }
        .onDisappear {
            if speechSynth.isSpeaking {
                speechSynth.stopSpeaking(at: .immediate)
            }
        }
        .alert("Erro", isPresented: .constant(errorMessage != nil), actions: {
            Button("OK") { errorMessage = nil }
        }, message: {
            Text(errorMessage ?? "")
        })
    }

    private func loadPickedImage(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                await MainActor.run {
                    self.selectedImage = image
                    self.recognizedText = ""
                }
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Não foi possível carregar a imagem da galeria."
            }
        }
    }

    private func analyzeCurrentImage() async {
        guard let uiImage = selectedImage else { return }
        isRecognizing = true
        defer { isRecognizing = false }

        guard let cgImage = uiImage.cgImage ?? uiImage.fixOrientation().cgImage else {
            errorMessage = "Imagem inválida para análise."
            return
        }

        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.recognitionLanguages = ["pt-BR", "pt-PT", "en-US"]

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        do {
            try handler.perform([request])

            let observations = request.results ?? []
            let text = observations.compactMap { $0.topCandidates(1).first?.string }
                                   .joined(separator: "\n")

            await MainActor.run {
                self.recognizedText = text
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Falha ao reconhecer o texto."
            }
        }
    }

    private func toggleSpeech() {
        if isSpeaking {
            speechSynth.stopSpeaking(at: .immediate)
            isSpeaking = false
            return
        }

        let content = recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty else { return }

        let utterance = AVSpeechUtterance(string: content)
        if let brVoice = AVSpeechSynthesisVoice(language: "pt-BR") {
            utterance.voice = brVoice
        }
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.pitchMultiplier = 1.0
        utterance.postUtteranceDelay = 0.0

        isSpeaking = true
        speechSynth.speak(utterance)
    }
}

private final class SpeechDelegate: NSObject, AVSpeechSynthesizerDelegate {
    @Binding var isSpeaking: Bool

    init(isSpeaking: Binding<Bool>) {
        self._isSpeaking = isSpeaking
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking = true
    }
}

private extension UIImage {
    func fixOrientation() -> UIImage {
        if imageOrientation == .up { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}

#Preview {
    ContentView()
}
