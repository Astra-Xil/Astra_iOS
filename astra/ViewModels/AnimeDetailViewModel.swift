import SwiftUI
import Combine
@MainActor
final class AnimeDetailViewModel: ObservableObject {
    @Published var anime: AnimeDetailUI?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let api = AnimeDetailAPI()

    func load(id: Int) async {
        isLoading = true
        errorMessage = nil

        do {
            anime = try await api.fetchAnimeDetail(id: id)
        } catch APIError.badStatus(let code) {
            errorMessage = "取得失敗（HTTP \(code)）"
        } catch {
            errorMessage = "取得に失敗しました"
        }

        isLoading = false
    }
}
