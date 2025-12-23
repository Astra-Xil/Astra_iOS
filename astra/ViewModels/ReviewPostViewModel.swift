import Foundation
import Combine

@MainActor
final class ReviewPostViewModel: ObservableObject {

    @Published var score: Double = 3
    @Published var comment: String = ""
    @Published var isSubmitting = false
    @Published var errorMessage: String?

    func submit(
        animeId: Int,
        accessToken: String
    ) async -> Bool {

        isSubmitting = true
        defer { isSubmitting = false }

        do {
            try await ReviewService.shared.postReview(
                animeId: animeId,
                score: score,
                comment: comment,
                accessToken: accessToken
            )
            return true
        } catch {
            errorMessage = "投稿に失敗しました"
            return false
        }
    }
}
