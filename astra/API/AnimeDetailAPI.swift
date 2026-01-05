import Foundation

enum APIError: Error {
    case badURL
    case badStatus(Int)
    case decode
}

final class AnimeDetailAPI {

    func fetchAnimeDetail(malId: Int) async throws -> AnimeDetailUI {
        guard let url = URL(
            string: "\(AppConfig.apiBaseURL)/api/anime/\(malId)"
        ) else {
            throw APIError.badURL
        }

        let (data, res) = try await URLSession.shared.data(from: url)

        if let http = res as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
            throw APIError.badStatus(http.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            return try decoder
                .decode(AnimeDetailResponse.self, from: data)
                .data
        } catch {
            throw APIError.decode
        }
    }
}
