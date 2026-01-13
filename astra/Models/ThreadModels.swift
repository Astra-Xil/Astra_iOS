//
//  ThreadModels.swift
//  astra
//
//  Created by Xil on 2026/01/13.
//

import Foundation


// =====================
// API Response
// =====================
struct ThreadListResponse: Decodable {
    let data: [ThreadDTO]
}

// =====================
// API Request
// =====================
struct ThreadCreateRequest: Encodable {
    let anime_id: Int
    let title: String
}

// =====================
// DTO
// =====================
struct ThreadDTO: Decodable {
    let id: UUID
    let animeId: Int
    let title: String
    let createdAt: Date
    let updatedAt: Date
    let profiles: Profile

    enum CodingKeys: String, CodingKey {
        case id
        case animeId = "anime_id"
        case title
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case profiles
    }
}

// =====================
// Domain Model
// =====================
struct ThreadItem: Identifiable {
    let id: UUID
    let animeId: Int
    let title: String
    let createdAt: Date
    let updatedAt: Date
    let profile: Profile
}

// =====================
// DTO → Domain
// =====================
extension ThreadItem {
    init(dto: ThreadDTO) {
        self.id = dto.id
        self.animeId = dto.animeId
        self.title = dto.title
        self.createdAt = dto.createdAt
        self.updatedAt = dto.updatedAt
        self.profile = dto.profiles
    }
}
