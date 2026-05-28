import SwiftUI

struct ContentView4: View {
    
    @State private var distancia: Double = 0.0
    @State private var tempo: Double = 0.0
    @State private var cor: String = "Amarelo"
    @State private var imagem: String = "interrogacao"
    @State private var resultado: Double = 0.0
    
    
    func atualizarValor(){
        resultado = distancia/tempo
        if tempo == 0.0 {
            resultado = 0
        }
        if resultado < 10{
            cor = "Verde"
            imagem = "tartaruga"
        } else if resultado < 30{
            cor = "Azul"
            imagem = "elefante"
        } else if resultado < 70{
            cor = "Laranja"
            imagem = "avestruz"
        } else if resultado < 90{
            cor = "Amarelo"
            imagem = "leao"
        } else if resultado < 130{
            cor = "Vermelho"
            imagem = "guepardo"
        } else {
            return
        }
    }
    
    var body: some View {
        ZStack{
            Color(cor).ignoresSafeArea()
            VStack{
                Text("Digite a distância (km)")
                
                TextField("0", value: $distancia, format: .number).multilineTextAlignment(.center).textFieldStyle(.roundedBorder).frame(width: 150)
                Text("Digite o tempo (h)")
                
                TextField("0", value: $tempo, format:.number).multilineTextAlignment(.center).textFieldStyle(.roundedBorder).frame(width: 150)
                Button(action: {
                    atualizarValor()
                }) {
                    Text("Calcular")
                        .bold()
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                }.padding()
                Text("\(resultado, specifier: "%.2f") km/h").font(.largeTitle)
                Image(imagem).resizable().scaledToFit().frame(width: 250, height: 250).cornerRadius(1000)
                    Spacer()
                Text("Tartaruga (0 - 9,9km/h)\nElefante (10 - 29,9km/h)\nAvestruz (30 - 69,9km/h)\nLeão (70 - 89,9km/h)\nGuepardo (90 - 130km/h) ").background(Color.black).foregroundColor(.white).multilineTextAlignment(.center).font(.title3)
                
                Spacer()
                
            }
            
        }
    }
}

#Preview {
    ContentView4()
}
