//
//  ChatServiceAPI.swift
//  astra
//
//  Created by Xil on 2026/01/06.
//
import Foundation

final class ChatServiceAPI {

    static let shared = ChatServiceAPI()
    private init() {}

    func postMessage(
        animeId: Int,
        message: String,
        accessToken: String
    ) async throws {

        let url = URL(string: "\(AppConfig.apiBaseURL)/chat")!
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let body = ChatPostRequest(
            anime_id: animeId,
            content: message
        )
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let res = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if 200..<300 ~= res.statusCode {
            return
        }

        if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
            throw NSError(
                domain: "ChatPost",
                code: res.statusCode,
                userInfo: [NSLocalizedDescriptionKey: apiError.error]
            )
        }

        throw URLError(.badServerResponse)
    }
}
