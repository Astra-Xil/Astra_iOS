import Foundation

enum APIError: Error {
    case badURL
    case badStatus(Int)
    case decode
}

final class AnimeDetailAPI {
    func fetchAnimeDetail(id: Int) async throws -> AnimeDetailUI {
        guard let url = URL(string: "\(AppConfig.apiBaseURL)/api/anime/\(id)") else {
            throw APIError.badURL
        }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        let (data, res) = try await URLSession.shared.data(for: req)

        if let http = res as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw APIError.badStatus(http.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(AnimeDetailResponse.self, from: data).data
        } catch {
            throw APIError.decode
        }
    }
}
