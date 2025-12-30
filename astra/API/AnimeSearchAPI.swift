import Foundation

enum AnimeAPI {

  static func search(q: String) async throws -> [AnimeSearchItem] {
    let encoded = q.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

    let url = URL(
      string: "\(AppConfig.apiBaseURL)/api/anime/search?q=\(encoded)"
    )!

    let (data, _) = try await URLSession.shared.data(from: url)

    let decoded = try JSONDecoder().decode(
      AnimeSearchResponse.self,
      from: data
    )

    return decoded.data
  }
}
