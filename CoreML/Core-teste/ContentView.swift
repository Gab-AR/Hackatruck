
import CoreML
import Vision
import SwiftUI

struct ContentView: View {
    
    @State private var selectedImage: UIImage? = UIImage(named: <#T##String#>)
    
    func classifyImage() {

        guard let uiImage = selectedImage,
              let ciImage = CIImage(image: uiImage) else {
            classificationLabel = "Erro ao converter imagem"
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
                    classificationLabel = "Nenhum resultado encontrado"
                }
            }

            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            DispatchQueue.global().async {
                do {
                    try handler.perform([request])
                } catch {
                    classificationLabel = "Erro na classificação: \(error.localizedDescription)"
                }
            }
        } catch {
            classificationLabel = "Falha ao carregar modelo ML"
        }
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
