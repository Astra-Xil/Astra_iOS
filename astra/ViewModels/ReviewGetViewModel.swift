import Foundation
import Combine

enum ReviewGetState {
    case idle
    case loading
    case loaded([Review])
    case error(String)
}


@MainActor
final class ReviewGetViewModel: ObservableObject {

    @Published var state: ReviewGetState = .idle
    private var hasLoaded = false
    private var loadedAnimeId: Int?

    func load(animeId: Int) async {
        // 同じ animeId で既に取得済みなら何もしない
        if hasLoaded, loadedAnimeId == animeId {
            return
        }

        hasLoaded = true
        loadedAnimeId = animeId
        state = .loading

        do {
            let reviews = try await ReviewServiceAPI.shared.fetchReviews(
                animeId: animeId
            )
            state = .loaded(reviews)
        } catch {
            state = .error("レビューの取得に失敗しました")
        }
    }
}
