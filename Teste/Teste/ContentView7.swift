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
        Conteudo(
            categorias: "Filme",
            nome: "O Poderoso Chefão",
            capa: "https://m.media-amazon.com/images/M/MV5BYTRmMjkwYzYtYTRiMi00NDJjLTk1NjctMDA3MjY2ZWIyMGQ5XkEyXkFqcGc@._V1_.jpg",
            ano: "1972",
            genero: "Crime, Drama",
            pais: "EUA",
            imdb: "9.2"
        ),
        Conteudo(
            categorias: "Filme",
            nome: "Batman: O Cavaleiro das Trevas",
            capa: "https://play-lh.googleusercontent.com/b0bqoD27ib25NwPutF8Kf740iiFQ53CKUz27VBQkCQtvSfhdWQtb8vwFxxn-SzI-5ZATXXkDwf2qPODkNQ",
            ano: "2008",
            genero: "Ação, Crime, Drama",
            pais: "EUA",
            imdb: "9.0"
        ),
        Conteudo(
            categorias: "Filme",
            nome: "A Viagem de Chihiro",
            capa: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrMavR7aT6L1P3EraTAsVwjqKr8QQhh-qDdg&s",
            ano: "2001",
            genero: "Animação, Aventura, Fantasia",
            pais: "Japão",
            imdb: "8.6"
        ),
        Conteudo(
            categorias: "Filme",
            nome: "Parasita",
            capa: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZrXu26D9I61d5cdzolbda9JvpB-zpcNmVzQ&s",
            ano: "2019",
            genero: "Drama, Suspense",
            pais: "Coreia do Sul",
            imdb: "8.5"
        ),
        Conteudo(
            categorias: "Filme",
            nome: "Cidade de Deus",
            capa: "https://play-lh.googleusercontent.com/hzB49wRFYtA-T5EvxgtrOLMp5SILwl49nyiOLEpNVtH6plGWK4TUGeDrkqs4wpPGPS3dhf0FKKHtAlKKPYwu",
            ano: "2002",
            genero: "Crime, Drama",
            pais: "Brasil",
            imdb: "8.6"
        ),
        
        Conteudo(
            categorias: "Série",
            nome: "Breaking Bad",
            capa: "https://m.media-amazon.com/images/M/MV5BMzU5ZGYzNmQtMTdhYy00OGRiLTg0NmQtYjVjNzliZTg1ZGE4XkEyXkFqcGc@._V1_QL75_UX190_CR0,2,190,281_.jpg",
            ano: "2008",
            genero: "Crime, Drama, Suspense",
            pais: "EUA",
            imdb: "9.5"
        ),
        Conteudo(
            categorias: "Série",
            nome: "Succession",
            capa: "https://m.media-amazon.com/images/M/MV5BZjZhZDc4N2QtZTEzYS00ZmY5LWE2ODctYTA0MWRjMDBmZTFiXkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg",
            ano: "2018",
            genero: "Drama",
            pais: "EUA",
            imdb: "8.8"
        ),
        Conteudo(
            categorias: "Série",
            nome: "Dark",
            capa: "https://m.media-amazon.com/images/M/MV5BMzgyNTk3NDktYWEzMS00M2M3LWI1NDUtMWNhZDUzZTllZTU0XkEyXkFqcGc@._V1_FMjpg_UX1000_.jpg",
            ano: "2017",
            genero: "Ficção Científica, Mistério, Drama",
            pais: "Alemanha",
            imdb: "8.7"
        ),
        Conteudo(
            categorias: "Série",
            nome: "Round 6",
            capa: "https://static.wikia.nocookie.net/round-6/images/e/ef/P%C3%B4ster_da_Temporada_1.png/revision/latest?cb=20250111190532&path-prefix=pt-br",
            ano: "2021",
            genero: "Ação, Drama, Mistério",
            pais: "Coreia do Sul",
            imdb: "8.0"
        ),
        Conteudo(
            categorias: "Série",
            nome: "Cangaço Novo",
            capa: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7C_dsg-2iBlOQzb4JsAxFDdXnuDAAp50EkA&s",
            ano: "2023",
            genero: "Ação, Crime, Drama",
            pais: "Brasil",
            imdb: "8.2"
        )
    ]
    
    var filmes: [Conteudo] {
            listaDeConteudos.filter { $0.categorias == "Filme" }
        }
        
    var series: [Conteudo] {
            listaDeConteudos.filter { $0.categorias == "Série" }
        }
        
        var body: some View {
            NavigationStack{
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
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Filmes")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                ForEach(filmes, id: \.self) { filme in 
                                    celulaConteudo(item: filme)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Séries")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                ForEach(series, id: \.self) { serie in
                                    celulaConteudo(item: serie)
                                }
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
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
            }
            .padding()
            .background(Color.black.opacity(0.2))
            .cornerRadius(12)
            .padding(.horizontal)
        }
        
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
