// Models/ReviewModels.swift
import Foundation

struct ReviewPostRequest: Codable {
    let anime_id: Int
    let score: Double
    let comment: String
}
