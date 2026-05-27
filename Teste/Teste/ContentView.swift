//
//  ContentView.swift
//  Teste
//
//  Created by Turma02 on 27/05/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            VStack {
                Spacer().frame(height: 15)
                HStack{
                    Spacer().frame(width: 15, height: 15)
                    Color.red
                        .frame(width: 100, height: 100)
                    Spacer()
                    Color.blue
                        .frame(width: 100, height: 100)
                    Spacer().frame(width: 15, height: 15)
                }
                Spacer()
                HStack{
                    Spacer().frame(width: 15, height: 15)
                    Color.green
                        .frame(width: 100, height: 100)
                    Spacer()
                    Color.yellow
                        .frame(width: 100, height: 100)
                    Spacer().frame(width: 15, height: 15)
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
