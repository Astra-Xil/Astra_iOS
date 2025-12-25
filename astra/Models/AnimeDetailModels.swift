//
//  AnimeDetailModels.swift
//  astra
//
//  Created by Xil on 2025/12/26.
//

import Foundation

struct AnimeDetailResponse: Decodable {
    let data: AnimeDetailUI
}

struct AnimeDetailUI: Decodable, Identifiable {
    let id: Int
    let title: String
    let titleSub: String?

    let imageUrl: String

    let hero: Hero
    let meta: Meta
    let synopsis: String
    let trailer: Trailer

    struct Hero: Decodable {
        let scoreText: String
        let episodesText: String
        let statusLabel: String
    }

    struct Meta: Decodable {
        let genres: [String]
        let studios: [String]
        let yearText: String
        let durationText: String
    }

    struct Trailer: Decodable {
        let youtubeId: String
        let thumbnailUrl: String
    }
}
