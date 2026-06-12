import Translation
import SwiftUI

struct Itens: Hashable{
    let nome: String
    let valor: String
    let foto: String
}

struct ContentView: View {
    @State private var arrayEntrada: [Itens] = [
        Itens(nome: "Steak Tartare", valor: "R$90,00", foto:"https://www.seriouseats.com/thmb/Nh6c2F7VA5VKLksBDeecld9LJNM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/20240910-SEA-SteakTartare-PeytonBeckwith-heroFINAL-02990d084f0a47388b2f7e2e5be040eb.jpg"),
        Itens(nome: "Dadinhos de tapioca", valor: "R$90,00", foto: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUyMg3W1NFVyPX7sKjAGkWCchHVyYdQWPgmQ&s")
        
    ]
    @State private var arrayPrincipal: [Itens] = [
        Itens(nome: "Bife de Chorizo", valor: "R$200,00", foto:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_9KEZnAe0hsn3m8bPw8UYux7BFA0Yqb7oiA&s"),
        Itens(nome: "Choripan", valor: "R$35,00", foto: "https://frigorificoarvoredo.com.br/blog/wp-content/uploads/2023/11/receita-de-choripan-.jpg")
    ]
    @State private var arrayBebida: [Itens] = [
        Itens(nome: "Coca-Zero", valor: "R$8,00", foto: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgDnyi_dDvpIEzIjoIqcMXkGTEda7SaICk9Q&s"),
        Itens(nome: "Cajuina", valor: "R$15,00", foto: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6mnST9XgqFVXk4_yv58clNvbDmfIoOG6blg&s")
    ]
    @State private var arraySobremesa: [Itens] = [
        Itens(nome: "Sorvete de Pistache", valor: "R$48,00", foto: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRm2z8KhfwRXD_68dKN5noHkX1k_P-RJMModg&s"),
        Itens(nome: "Pudim", valor: "R$36,00", foto: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyk9GXd4VX06RS7EmGhlSxqrfvHTXnx1UceA&s")
    ]
    
    
    
    private let headerYellow = Color(red: 1.0, green: 0.95, blue: 0.6)
    private let sectionBlue = Color(red: 0.76, green: 0.91, blue: 1.0)
    private let titleTextColor = Color.black
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Sapo's GastroBar")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(titleTextColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .background(headerYellow)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                        .padding(.top)

                    SectionView(title: "ENTRADA", items: arrayEntrada, headerYellow: headerYellow, sectionBlue: sectionBlue)
                    SectionView(title: "PRINCIPAL", items: arrayPrincipal, headerYellow: headerYellow, sectionBlue: sectionBlue)
                    SectionView(title: "Sobremesa", items: arraySobremesa, headerYellow: headerYellow, sectionBlue: sectionBlue)
                    SectionView(title: "BEBIDA", items: arrayBebida, headerYellow: headerYellow, sectionBlue: sectionBlue)
                }
                .padding(.bottom, 16)
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct SectionView: View {
    let title: String
    let items: [Itens]
    let headerYellow: Color
    let sectionBlue: Color
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(headerYellow)

            VStack(spacing: 8) {
                ForEach(items, id: \.self) { item in
                    ItemRow(item: item)
                }
            }
            .padding(8)
            .background(sectionBlue)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

private struct ItemRow: View {
    let item: Itens
    @State private var showTranslation = false
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: item.foto)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.gray.opacity(0.2)
                        ProgressView()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    ZStack {
                        Color.gray.opacity(0.2)
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                @unknown default:
                    Color.gray.opacity(0.2)
                }
            }
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.nome)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Text(item.valor)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button("Traduzir"){showTranslation = true}.translationPresentation(isPresented: $showTranslation, text: item.nome)
        }
        .padding(8)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    ContentView()
}
