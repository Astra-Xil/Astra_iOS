import SwiftUI
import Combine
enum AnimeDetailState {
    case idle
    case loading
    case loaded(AnimeDetailUI)
    case error(String)
}
@MainActor
final class AnimeDetailViewModel: ObservableObject {

    @Published var state: AnimeDetailState = .idle
    private let api = AnimeDetailAPI()

    func load(id: Int) async {
        state = .loading

        do {
            let anime = try await api.fetchAnimeDetail(malId: id)
            state = .loaded(anime)
        } catch APIError.badStatus(let code) {
            state = .error("取得失敗（HTTP \(code)）")
        } catch {
            state = .error("取得に失敗しました")
        }
    }
}

