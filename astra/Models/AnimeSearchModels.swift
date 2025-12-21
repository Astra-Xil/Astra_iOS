import Foundation

struct AnimeSearchResponse: Decodable {
  let data: [AnimeSearchItem]
}

struct AnimeSearchItem: Decodable, Identifiable {
  let id: Int
  let title: String
  let imageUrl: String
  let episodes: Int?
  let genres: [String]
}
