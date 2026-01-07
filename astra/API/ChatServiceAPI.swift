////
////  ChatServiceAPI.swift
////  astra
////
////  Created by Xil on 2026/01/06.
////
import Foundation

final class ChatServiceAPI {

    static let shared = ChatServiceAPI()
    private init() {}

    func postMessage(
        animeId: Int,
        message: String,
        accessToken: String
    ) async throws -> ChatMessageDTO {

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
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601   // ★超重要
            return try decoder.decode(ChatMessageDTO.self, from: data)
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
extension ChatServiceAPI {

    func fetchInitialMessages(
        animeId: Int,
        accessToken: String
    ) async throws -> [ChatMessage] {

        var components = URLComponents(
            string: "\(AppConfig.apiBaseURL)/chat"
        )!
        components.queryItems = [
            URLQueryItem(name: "anime_id", value: String(animeId))
        ]

        var req = URLRequest(url: components.url!)
        req.httpMethod = "GET"
        req.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: req)

        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let result = try decoder.decode(ChatListResponse.self, from: data)

        return result.data.map {
            ChatMessage(
                id: $0.id,
                animeId: $0.animeId,
                content: $0.content,
                createdAt: $0.createdAt,
                userId: $0.userId,
                profile: $0.profiles
            )
        }


    }
}
