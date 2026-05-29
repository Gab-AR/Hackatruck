import SwiftUI

struct RosaView: View {
    var body: some View {
        ZStack{
            Color.pink.ignoresSafeArea()
            Circle().foregroundColor(.black).padding()
            VStack{
                Image(systemName: "paintbrush").resizable().scaledToFit().frame(width: 250, height: 250).foregroundColor(.pink)
                
            }
        }
    }
}

struct AzulView: View {
    var body: some View {
        ZStack{
            Color.blue.ignoresSafeArea()
            Circle().foregroundColor(.black).padding()
            VStack{
                Image(systemName: "paintbrush.pointed").resizable().scaledToFit().frame(width: 250, height: 250).foregroundColor(.blue)
                
            }
        }
    }
}

struct CinzaView: View {
    var body: some View {
        ZStack{
            Color.gray.ignoresSafeArea()
            Circle().foregroundColor(.black).padding()
            VStack{
                Image(systemName: "paintpalette").resizable().scaledToFit().frame(width: 250, height: 250).foregroundColor(.gray)
                
            }
        }
    }
}

struct ListaView: View {
    var body: some View {
        List {
            Text("Tela Rosa")
            Text("Tela Azul")
            Text("Tela Cinza")
        }
    }
}

struct ContentView5: View {
    
    
    var body: some View {
        
        TabView{
            RosaView().tabItem{Label("Rosa", systemImage: "paintbrush.fill")
                }
            AzulView().tabItem{
                Label("Azul", systemImage: "paintbrush.pointed.fill")
            }
            CinzaView().tabItem{Label("Cinza", systemImage: "paintpalette.fill")
            }
            ListaView().tabItem{Label("Lista", systemImage: "list.bullet")
            }
        }
    }
}

#Preview {
    ContentView5()
}
