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
    let id: Int
    let anime_id: Int
    let score: Double
    let comment: String
    let user_id: String
    let created_at: Date
}
