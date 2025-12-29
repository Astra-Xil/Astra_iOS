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
        errorMessage = nil
        defer { isSubmitting = false }

        do {
            try await ReviewServiceAPI.shared.postReview(
                animeId: animeId,
                score: score,
                comment: comment,
                accessToken: accessToken
            )
            return true

        } catch let error as NSError {
            // ✅ API が返した error をそのまま表示
            errorMessage = error.localizedDescription
            return false

        } catch {
            // 念のための保険
            errorMessage = "通信エラーが発生しました"
            return false
        }
    }

}
