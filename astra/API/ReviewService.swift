import Foundation

final class ReviewService {

    static let shared = ReviewService()
    private init() {}

    func postReview(
        animeId: Int,
        score: Double,
        comment: String,
        accessToken: String
    ) async throws {
        print("accessToken:", accessToken)
        let url = URL(string: "https://astra-ewy.pages.dev/api/reviews")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            "Bearer \(accessToken)",
            forHTTPHeaderField: "Authorization"
        )

        let body = ReviewPostRequest(
            anime_id: animeId,
            score: score,
            comment: comment
        )

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let res = response as? HTTPURLResponse {
            print("statusCode:", res.statusCode)
            print("body:", String(data: data, encoding: .utf8) ?? "nil")
        }
        
        guard let res = response as? HTTPURLResponse,
              200..<300 ~= res.statusCode else {
            throw URLError(.badServerResponse)
        }
        
    }
}
