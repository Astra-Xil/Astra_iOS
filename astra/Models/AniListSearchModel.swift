//
//  AniListSearchModel.swift
//  astra
//
//  Created by Xil on 2026/01/03.
//

import Foundation
import Foundation

struct AniListSearchResponse: Decodable {
    let data: DataContainer

    struct DataContainer: Decodable {
        let Page: PageContainer
    }

    struct PageContainer: Decodable {
        let media: [Media]
    }

    struct Media: Decodable {
        let id: Int
        let idMal: Int?
        let title: Title
        let genres: [String]
        let coverImage: CoverImage?

        struct Title: Decodable {
            let native: String?
            let romaji: String?
            let english: String?
        }

        struct CoverImage: Decodable {
            let large: String?
            let color: String?
        }
    }
}

struct AniListSearchItem: Identifiable {
    let id: Int          // malId を id に使う
    let title: String
    let genres: [String]
    let imageUrl: String
}

