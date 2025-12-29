import Foundation

final class ReviewServiceAPI {

    static let shared = ReviewServiceAPI()
    private init() {}

    func postReview(
        animeId: Int,
        score: Double,
        comment: String,
        accessToken: String
    ) async throws {

        let url = URL(string: "https://untactile-holeless-wilda.ngrok-free.dev/reviews")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let body = ReviewPostRequest(
            anime_id: animeId,
            score: score,
            comment: comment
        )
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let res = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        // ✅ 成功
        if 200..<300 ~= res.statusCode {
            return
        }

        // ✅ 失敗：API の error を読む
        if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
            throw NSError(
                domain: "ReviewPost",
                code: res.statusCode,
                userInfo: [NSLocalizedDescriptionKey: apiError.error]
            )
        }

        throw URLError(.badServerResponse)
    }
}
extension ReviewServiceAPI {

    func fetchReviews(animeId: Int) async throws -> [Review] {
        var components = URLComponents(
            string: "https://backendastra.yuki-2002-828.workers.dev/reviews"
        )!
        components.queryItems = [
            URLQueryItem(name: "anime_id", value: String(animeId))
        ]

        let url = components.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let res = response as? HTTPURLResponse,
              200..<300 ~= res.statusCode else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let decoded = try decoder.decode(ReviewResponse.self, from: data)
        return decoded.data
    }
}
