
import Foundation

struct APIService {
    enum APIError: Error {
        case badURL
        case requestFailed(Int)
        case decodingFailed(Error)
        case unknown
    }

    func fetchCharacters(byHouse house: String) async throws -> [HaPo] {
        let urlString = "https://hp-api.onrender.com/api/characters/house/\(house)"
        guard let url = URL(string: urlString) else {
            throw APIError.badURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw APIError.requestFailed(http.statusCode)
        }

        do {
            return try JSONDecoder().decode([HaPo].self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
}
