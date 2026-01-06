//
//  ChatModels.swift
//  astra
//
//  Created by Xil on 2026/01/06.
//

import Foundation


//struct ChatPostRequest: Encodable {
//    let anime_id: Int
//    let content: String
//}
//struct ChatMessage: Identifiable {
//    let id: UUID
//    let animeId: Int
//    let content: String
//    let createdAt: Date
//    let userId: UUID
//    var profile: Profile?
//}
//
//
//struct ChatMessageDTO: Decodable {
//    let id: UUID
//    let animeId: Int
//    let content: String
//    let createdAt: Date
//    let userId: UUID
//    let profiles: Profile?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case animeId   = "anime_id"
//        case content
//        case createdAt = "created_at"
//        case userId    = "user_id"
//        case profiles
//    }
//}
struct ChatMessage: Codable, Identifiable {
    let id: UUID
    let animeId: Int
    let content: String
    let userName: String
    let createdAt: String
}
