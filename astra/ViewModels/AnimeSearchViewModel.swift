import Foundation
import Combine
@MainActor
final class AnimeSearchViewModel: ObservableObject {

  @Published var result: [AnimeSearchItem] = []
  @Published var isLoading = false

  func loadAnime(q: String) async {
    guard !q.isEmpty else { return }

    isLoading = true
    defer { isLoading = false }

    do {
      result = try await AnimeAPI.search(q: q)
    } catch {
      print("search error:", error)
      result = []
    }
  }
}
