//
//  ProfileModels.swift
//  astra
//
//  Created by Xil on 2026/01/05.
//
import Foundation

struct Profile: Decodable {
    let name: String
    let avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case name
        case avatarUrl = "avatar_url"
    }
}
struct BroadcastProfile: Codable{
    let name: String
    let avatarUrl: String?
}
