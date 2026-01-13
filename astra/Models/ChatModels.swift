//
//  ChatModels.swift
//  astra
//
//  Created by Xil on 2026/01/06.
//

import Foundation
struct ChatListResponse: Decodable {
    let data: [ChatMessageDTO]
}


struct ChatPostRequest: Encodable {
    let anime_id: Int
    let thread_id: UUID
    let content: String
}

struct ChatMessage: Identifiable {
    let id: UUID
    let animeId: Int
    let content: String
    let createdAt: Date
    let userId: UUID
    let profile: Profile?
}



struct ChatMessageDTO: Decodable {
    let id: UUID
    let animeId: Int
    let content: String
    let createdAt: Date
    let userId: UUID
    let profiles: Profile?

    enum CodingKeys: String, CodingKey {
        case id
        case animeId   = "anime_id"
        case content
        case createdAt = "created_at"
        case userId    = "user_id"
        case profiles
    }
}
struct BroadcastMessage: Codable, Identifiable {
    let id: UUID
    let animeId: Int
    let content: String
    let createdAt: Date
    let userId: UUID
    let profile: BroadcastProfile?
}
extension ChatMessage {
    init(dto: ChatMessageDTO) {
        self.id = dto.id
        self.animeId = dto.animeId
        self.content = dto.content
        self.createdAt = dto.createdAt
        self.userId = dto.userId
        self.profile = dto.profiles
    }
}
extension BroadcastMessage {
    init(from message: ChatMessage) {
        self.id = message.id
        self.animeId = message.animeId
        self.content = message.content
        self.createdAt = message.createdAt
        self.userId = message.userId
        self.profile = message.profile.map {
            BroadcastProfile(
                name: $0.name,
                avatarUrl: $0.avatarUrl
            )
        }
    }
}
