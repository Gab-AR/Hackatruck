import SwiftUI

struct ContentView3: View {
    
    @State private var exibirAlerta = false
    @State private var textoDigitado: String = ""
    
    var body: some View {
        ZStack{
            VStack(){
                Text("Bem vindo, \(textoDigitado)!").font(.largeTitle).offset(y:-30)
                
                TextField("Digite seu nome aqui", text: $textoDigitado).multilineTextAlignment(.center).offset(y:-30)
                    .padding()
                AsyncImage(url:URL(string: "https://m.media-amazon.com/images/I/41UeVERMojL._UXNaN_FMjpg_QL85_.jpg"), scale: 1).opacity(0.5)
                    .padding()
                Button(action: {
                                exibirAlerta = true
                }) {
                    Text("Entrar")
                        .bold()
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                }.offset(y:50)
                    .alert("Atenção", isPresented: $exibirAlerta) {
                        Button("OK", role: .cancel) { }
                    }message: {
                        Text("Ainda não desenvolvi a parte do login")
                    }
            }
            AsyncImage(url:URL(string: "https://psddesign.com.br/wp-content/uploads/2024/01/12853-logo-academia-strong.webp"), scale: 5).offset(y:80)
        }
    }
}

#Preview {
    ContentView3()
}
