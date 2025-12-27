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

    func load(animeId: Int) async {
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
