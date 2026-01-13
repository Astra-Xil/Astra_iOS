//
//  ThreadServiceAPI.swift
//  astra
//
//  Created by Xil on 2026/01/13.
//
import Foundation

final class ThreadServiceAPI {

    static let shared = ThreadServiceAPI()

    func fetchThreads(animeId: Int) async throws -> [ThreadItem] {
        let url = URL(string: "\(AppConfig.apiBaseURL)/threads?anime_id=\(animeId)")!
        let (data, _) = try await URLSession.shared.data(from: url)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let res = try decoder.decode(ThreadListResponse.self, from: data)
        return res.data.map(ThreadItem.init)
    }

    func createThread(
        animeId: Int,
        title: String,
        accessToken: String
    ) async throws -> ThreadItem {
        let url = URL(string: "\(AppConfig.apiBaseURL)/threads")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ThreadCreateRequest(anime_id: animeId, title: title)
        req.httpBody = try JSONEncoder().encode(body)

        let (data, _) = try await URLSession.shared.data(for: req)
        print("THREAD RAW:", String(data: data, encoding: .utf8) ?? "nil")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let dto = try decoder.decode(ThreadDTO.self, from: data)

        return ThreadItem(dto: dto)
    }
}
