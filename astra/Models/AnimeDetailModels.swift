import Foundation

struct AnimeDetailResponse: Decodable {
    let data: AnimeDetailUI
}

struct AnimeDetailUI: Decodable, Identifiable {
    let id: Int
    let title: String

    let hero: Hero
    let meta: Meta
    let images: Images

    let synopsis: String?
    let trailer: Trailer?
    let siteUrl: String?
    let externalLinks: [ExternalLink]?

    // MARK: - Hero
    struct Hero: Decodable {
        let episodesText: String?
        let statusText: String?
    }

    // MARK: - Meta
    struct Meta: Decodable {
        let seasonYear: Int?
        let season: String?
        let genres: [String]?
        let studios: [String]?
        let durationText: String?
    }

    // MARK: - Images
    struct Images: Decodable {
        let coverLarge: String?
        let coverColor: String?
        let banner: String?
    }

    // MARK: - Trailer
    struct Trailer: Decodable {
        let youtubeId: String
        let url: String
    }

    // MARK: - ExternalLink
    struct ExternalLink: Decodable, Identifiable {
        var id: String { site + url }

        let site: String
        let url: String
        let icon: String?
    }
}
