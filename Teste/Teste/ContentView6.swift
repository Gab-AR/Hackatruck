import SwiftUI



struct ContentView6: View {
    
    var body: some View {
        ZStack{
            VStack{
                Text("Menu de Cores").font(.largeTitle).bold()
                Spacer()
                VStack{
                    Spacer()
                    HStack{
                        Button(action: {                }) {
                            Image(systemName: "paintbrush").resizable().scaledToFit().frame(width: 150, height: 150).foregroundColor(.white).background(Color.pink).cornerRadius(15)
                            
                        }.padding()
                        
                        Button(action: {                }) {
                            Image(systemName: "paintbrush.pointed").resizable().scaledToFit().frame(width: 150, height: 150).foregroundColor(.white).background(Color.blue).cornerRadius(15)
                            
                        }.padding()
                    }
                    HStack{
                        Button(action: {                }) {
                            Image(systemName: "paintpalette").resizable().scaledToFit().frame(width: 150, height: 150).foregroundColor(.white).background(Color.gray).cornerRadius(15)
                            
                        }.padding()
                        Button(action: {                }) {
                            Image(systemName: "list.bullet").resizable().scaledToFit().frame(width: 150, height: 150).foregroundColor(.white).background(Color.purple).cornerRadius(15)
                            
                        }.padding()
                        
                    }
                    Spacer()
                }
            }
            
        }
        
    }
}

#Preview {
    ContentView6()
}
