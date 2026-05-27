//
//  ContentView.swift
//  Teste
//
//  Created by Turma02 on 27/05/26.
//

import SwiftUI

struct ContentView2: View {
    var body: some View {
        ZStack{
            VStack {
                HStack{
                    Spacer()
                    AsyncImage(url:URL(string: "https://m.media-amazon.com/images/I/41UeVERMojL._UXNaN_FMjpg_QL85_.jpg"), scale: 4)
                        .clipShape(.rect(cornerRadius:100))
                    VStack{
                        Text("Hackatruck").frame(height: 15)
                            .foregroundColor(.red)
                        Text("Gabriel Rocha").frame(height: 15)
                            .foregroundColor(.blue)
                        Text("Programador").frame(height: 15)
                            .foregroundColor(.orange)
                    }
                    
                    Spacer()
                }
                
            }
        }
    }
}

#Preview {
    ContentView2()
}
