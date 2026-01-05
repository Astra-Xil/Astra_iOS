//
//  ChatModels.swift
//  astra
//
//  Created by Xil on 2026/01/06.
//

import Foundation


struct ChatPostRequest: Encodable {
    let anime_id: Int
    let content: String
}


struct ChatMessage: Decodable {
    let animeId: Int
    let content: String

    enum CodingKeys: String, CodingKey {
        case animeId = "anime_id"
        case content
    }
}
