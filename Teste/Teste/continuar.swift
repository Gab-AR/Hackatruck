import SwiftUI

struct ContentView7: View {
    
    struct Conteudo: Hashable {
        let categorias: String
        let nome: String
        let capa: String
        let ano: String
        let genero: String
        let pais: String
        let imdb: String
    }
    
    let listaDeConteudos: [Conteudo] = [
        Conteudo(categorias: "Filme", nome: "O Poderoso Chefão", capa: "https://via.placeholder.com/150", ano: "1972", genero: "Crime, Drama", pais: "EUA", imdb: "9.2"),
        Conteudo(categorias: "Filme", nome: "Batman: O Cavaleiro das Trevas", capa: "https://via.placeholder.com/150", ano: "2008", genero: "Ação, Crime, Drama", pais: "EUA", imdb: "9.0"),
        Conteudo(categorias: "Filme", nome: "A Viagem de Chihiro", capa: "https://via.placeholder.com/150", ano: "2001", genero: "Animação, Aventura, Fantasia", pais: "Japão", imdb: "8.6"),
        Conteudo(categorias: "Filme", nome: "Parasita", capa: "https://via.placeholder.com/150", ano: "2019", genero: "Drama, Suspense", pais: "Coreia do Sul", imdb: "8.5"),
        Conteudo(categorias: "Filme", nome: "Cidade de Deus", capa: "https://via.placeholder.com/150", ano: "2002", genero: "Crime, Drama", pais: "Brasil", imdb: "8.6"),
        
        Conteudo(categorias: "Série", nome: "Breaking Bad", capa: "https://via.placeholder.com/150", ano: "2008", genero: "Crime, Drama, Suspense", pais: "EUA", imdb: "9.5"),
        Conteudo(categorias: "Série", nome: "Succession", capa: "https://via.placeholder.com/150", ano: "2018", genero: "Drama", pais: "EUA", imdb: "8.8"),
        Conteudo(categorias: "Série", nome: "Dark", capa: "https://via.placeholder.com/150", ano: "2017", genero: "Ficção Científica, Mistério, Drama", pais: "Alemanha", imdb: "8.7"),
        Conteudo(categorias: "Série", nome: "Round 6", capa: "https://via.placeholder.com/150", ano: "2021", genero: "Ação, Drama, Mistério", pais: "Coreia do Sul", imdb: "8.0"),
        Conteudo(categorias: "Série", nome: "Cangaço Novo", capa: "https://via.placeholder.com/150", ano: "2023", genero: "Ação, Crime, Drama", pais: "Brasil", imdb: "8.2")
    ]
    
    var filmes: [Conteudo] {
        listaDeConteudos.filter { $0.categorias == "Filme" }
    }
    
    var series: [Conteudo] {
        listaDeConteudos.filter { $0.categorias == "Série" }
    }
    
    var body: some View {
        // 1. NavigationStack gerencia a pilha de telas e a barra de navegação no topo
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        Image("gabriel")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 140)
                            .padding(.top, 10)
                        
                        // --- SEÇÃO DE FILMES ---
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Filmes")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ForEach(filmes, id: \.self) { filme in
                                // 2. Envolvemos a célula com o NavigationLink para torná-la clicável
                                NavigationLink(destination: DetalheConteudoView(item: filme)) {
                                    celulaConteudo(item: filme)
                                }
                                .buttonStyle(PlainButtonStyle()) // Remove a cor azul padrão de link do iOS
                            }
                        }
                        
                        // --- SEÇÃO DE SÉRIES ---
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Séries")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ForEach(series, id: \.self) { serie in
                                NavigationLink(destination: DetalheConteudoView(item: serie)) {
                                    celulaConteudo(item: serie)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Catálogo") // Título opcional para a barra superior
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private func celulaConteudo(item: Conteudo) -> some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: item.capa)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 50, height: 75)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 75)
                        .cornerRadius(8)
                        .clipped()
                case .failure:
                    Image(systemName: "film")
                        .foregroundColor(.white)
                        .frame(width: 50, height: 75)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(item.nome)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack {
                    Text(converterPaisParaBandeira(item.pais))
                        .font(.title3)
                    Text(item.pais)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            Spacer()
            
            // Ícone indicando que o elemento leva a outra tela
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// --- 3. NOVA TELA DE DETALHES ---
struct DetalheConteudoView: View {
    let item: ContentView7.Conteudo // Recebe o filme ou série selecionado
    
    var body: some View {
        ZStack {
            // Mantém a identidade visual com o gradiente de fundo
            LinearGradient(
                colors: [.purple, .black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Capa grande em destaque
                    AsyncImage(url: URL(string: item.capa)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 300)
                                .cornerRadius(16)
                                .shadow(radius: 10)
                        } else {
                            Image(systemName: "film")
                                .font(.system(size: 80))
                                .foregroundColor(.white.opacity(0.6))
                                .frame(width: 200, height: 300)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(16)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Informações textuais
                    VStack(alignment: .leading, spacing: 15) {
                        Text(item.nome)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        
                        // Linha com Ano, Categoria e Nota IMDB
                        HStack(spacing: 15) {
                            Text(item.ano)
                            Text("•")
                            Text(item.categorias)
                            Text("•")
                            HStack(spacing: 3) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(item.imdb)
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        // Gênero
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Gênero")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                                .uppercaseSmallCaps()
                            Text(item.genero)
                                .font(.body)
                                .foregroundColor(.white)
                        }
                        
                        // País de Origem
                        VStack(alignment: .leading, spacing: 5) {
                            Text("País de Origem")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                                .uppercaseSmallCaps()
                            HStack {
                                Text(converterPaisParaBandeira(item.pais))
                                Text(item.pais)
                                    .font(.body)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                }
            }
        }
        .navigationTitle(item.nome)
        .navigationBarTitleDisplayMode(.inline)
        // Garante que o botão de "Voltar" gerado automaticamente adote a cor branca
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    // Duplicamos a lógica de bandeira aqui para fins de simplicidade estrutural
    private func converterPaisParaBandeira(_ pais: String) -> String {
        switch pais {
        case "EUA": return "🇺🇸"
        case "Brasil": return "🇧🇷"
        case "Japão": return "🇯🇵"
        case "Coreia do Sul": return "🇰🇷"
        case "Alemanha": return "🇩🇪"
        default: return "🏳️"
        }
    }
}

#Preview {
    ContentView7()
}
