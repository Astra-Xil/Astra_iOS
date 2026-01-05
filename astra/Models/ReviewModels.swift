// Models/ReviewModels.swift
import Foundation

struct ReviewPostRequest: Codable {
    let anime_id: Int
    let score: Double
    let comment: String
}
struct APIErrorResponse: Decodable {
    let error: String
}


struct ReviewResponse: Decodable {
    let data: [Review]
}

struct Review: Decodable, Identifiable {
    let id: UUID
    let score: Int?
    let comment: String?
    let createdAt: Date
    let userId: UUID?
    let profiles: Profile?

    enum CodingKeys: String, CodingKey {
        case id
        case score
        case comment
        case createdAt = "created_at"
        case userId = "user_id"
        case profiles
    }
}
