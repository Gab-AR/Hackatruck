import Foundation

// Modelo principal (mapeando os campos snake_case e _id/_rev do JSON)
struct UFPIItem: Codable, Identifiable, Equatable {
    let id: String            // _id
    var rev: String?          // _rev
    var nome: String
    var anoLancamento: Int
    var numeroVendas: Int
    var urlCapa: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case rev = "_rev"
        case nome
        case anoLancamento = "ano_lancamento"
        case numeroVendas = "numero_vendas"
        case urlCapa = "url_capa"
    }

    static let sample = UFPIItem(
        id: "037df9b54e0dc96496393e8df4b59a57",
        rev: "1-6955e4f65674a587b73199ec8e0cee41",
        nome: "Garry's Mod",
        anoLancamento: 2006,
        numeroVendas: 85_300_000,
        urlCapa: "https://cdn.cloudflare.steamstatic.com/steam/apps/400/header.jpg"
    )
}

// Payload para criar (POST)
struct UFPIItemCreate: Codable, Equatable {
    var nome: String
    var anoLancamento: Int
    var numeroVendas: Int
    var urlCapa: String

    enum CodingKeys: String, CodingKey {
        case nome
        case anoLancamento = "ano_lancamento"
        case numeroVendas = "numero_vendas"
        case urlCapa = "url_capa"
    }
}

// Payload para atualizar (PUT)
struct UFPIItemUpdate: Codable, Equatable {
    var id: String
    var rev: String
    var nome: String
    var anoLancamento: Int
    var numeroVendas: Int
    var urlCapa: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case rev = "_rev"
        case nome
        case anoLancamento = "ano_lancamento"
        case numeroVendas = "numero_vendas"
        case urlCapa = "url_capa"
    }
}

// Payload para excluir (DELETE)
struct UFPIItemDelete: Codable {
    var id: String
    var rev: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case rev = "_rev"
    }
}

// Resposta típica de escrita (CouchDB-like)
struct DBAck: Decodable {
    let ok: Bool?
    let id: String?
    let rev: String?
    let error: String?
    let reason: String?
}
