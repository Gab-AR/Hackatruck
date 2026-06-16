import Foundation

final class UFPIService {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(baseURL: URL = URL(string: "http://127.0.0.1:1880")!,
         session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session

        let decoder = JSONDecoder()
        // As chaves já estão mapeadas via CodingKeys
        self.decoder = decoder

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.withoutEscapingSlashes]
        self.encoder = encoder
    }

    // GET /getufpi
    func fetchItems() async throws -> [UFPIItem] {
        let url = baseURL.appendingPathComponent("getufpi")
        let (data, response) = try await session.data(from: url)
        try Self.ensureSuccess(response: response, data: data)

        // Tenta decodificar uma lista; se vier um único objeto, embrulha em array
        if let list = try? decoder.decode([UFPIItem].self, from: data) {
            return list
        } else if let single = try? decoder.decode(UFPIItem.self, from: data) {
            return [single]
        } else {
            throw APIError.decodingFailed
        }
    }

    // POST /postufpi
    func create(_ newItem: UFPIItemCreate) async throws -> DBAck? {
        let url = baseURL.appendingPathComponent("postufpi")
        let body = try encoder.encode(newItem)
        let data = try await send(url: url, method: "POST", body: body)
        // Algumas APIs retornam o doc, outras um "ack"
        if let ack = try? decoder.decode(DBAck.self, from: data) {
            return ack
        } else {
            _ = try decoder.decode(UFPIItem.self, from: data) // se retornar o item
            return nil
        }
    }

    // PUT /putufpi
    func update(_ updated: UFPIItemUpdate) async throws -> DBAck? {
        let url = baseURL.appendingPathComponent("putufpi")
        let body = try encoder.encode(updated)
        let data = try await send(url: url, method: "PUT", body: body)
        if let ack = try? decoder.decode(DBAck.self, from: data) {
            return ack
        } else {
            _ = try decoder.decode(UFPIItem.self, from: data)
            return nil
        }
    }

    // DELETE /deleteufpi
    // Assumindo que o endpoint recebe JSON com _id e _rev no corpo.
    func delete(id: String, rev: String) async throws -> DBAck? {
        let url = baseURL.appendingPathComponent("deleteufpi")
        let payload = UFPIItemDelete(id: id, rev: rev)
        let body = try encoder.encode(payload)
        let data = try await send(url: url, method: "DELETE", body: body)
        if let ack = try? decoder.decode(DBAck.self, from: data) {
            return ack
        } else {
            return nil
        }
    }

    // MARK: - Helpers

    private func send(url: URL, method: String, body: Data?) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, response) = try await session.data(for: request)
        try Self.ensureSuccess(response: response, data: data)
        return data
    }

    private static func ensureSuccess(response: URLResponse, data: Data) throws {
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            let serverMessage = String(data: data, encoding: .utf8) ?? ""
            throw APIError.httpError(status: http.statusCode, body: serverMessage)
        }
    }
}

enum APIError: LocalizedError {
    case invalidResponse
    case httpError(status: Int, body: String)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Resposta inválida do servidor."
        case .httpError(let status, let body):
            return "Erro HTTP \(status): \(body)"
        case .decodingFailed:
            return "Falha ao decodificar os dados."
        }
    }
}
