import SwiftUI

struct ReviewSectionView: View {

    let animeId: Int
    @StateObject private var vm = ReviewGetViewModel()

    var body: some View {
        content
        .task(id: animeId) {
            await vm.load(animeId: animeId)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {

        case .idle, .loading:
            ProgressView()
                .padding(.vertical, 16)

        case .loaded(let reviews):
            if reviews.isEmpty {
                Text("まだレビューはありません")
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 12) {
                    ForEach(reviews) { review in
                        ReviewCard(review: review)
                        Divider()
                    }
                }
            }

        case .error(let message):
            Text(message)
                .foregroundStyle(.red)
        }
    }
}
// MARK: - ReviewCard
struct ReviewCard: View {

    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // ユーザー行（アイコン + 名前）
            HStack(spacing: 8) {

                // プロフィール画像
                AsyncImage(
                    url: URL(string: review.profiles?.avatarUrl ?? "")
                ) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())

                // 名前
                Text(review.profiles?.name ?? "Unknown")
                    .font(.caption)
                    .fontWeight(.medium)

                Spacer()
            }

            StarRatingView(
                rating: .constant(Double(review.score ?? 0)),
                isEditable: false, starSize: 12, spacing: 0
            )

            // コメント
            if let comment = review.comment, !comment.isEmpty {
                Text(comment)
                    .font(.footnote)
                    
            }
        }
        .padding(.vertical, 8)
    }
}
