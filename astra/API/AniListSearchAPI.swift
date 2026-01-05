import Foundation

// MARK: - API
import Foundation
import Foundation

protocol AniListSearchAPIProtocol {
    func search(query: String) async throws -> [AniListSearchItem]
}

final class AniListSearchAPI: AniListSearchAPIProtocol {

    private let endpoint = URL(string: "https://graphql.anilist.co")!

    func search(query: String) async throws -> [AniListSearchItem] {

        let gql = """
        query ($search: String) {
          Page(perPage: 10) {
            media(type: ANIME, search: $search, isAdult: false) {
              id
              idMal
              title {
                native
                romaji
                english
              }
              genres
              coverImage {
                large
                color
              }
            }
          }
        }
        """

        let body: [String: Any] = [
            "query": gql,
            "variables": ["search": query]
        ]

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(AniListSearchResponse.self, from: data)

        return decoded.data.Page.media.compactMap { media in
            guard
                let malId = media.idMal,
                let imageUrl = media.coverImage?.large
            else { return nil }

            return AniListSearchItem(
                id: malId,
                title: media.title.native
                    ?? media.title.english
                    ?? media.title.romaji
                    ?? "Unknown",
                genres: media.genres,
                imageUrl: imageUrl
            )
        }
    }
}
