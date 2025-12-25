import SwiftUI

struct ReviewPostView: View {

    let animeId: Int
    let accessToken: String

    @StateObject private var vm = ReviewPostViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {

            // =======================
            // 評価（星）
            // =======================
            Section("評価") {
                StarRatingView(rating: $vm.score)
                Text("⭐️ \(vm.score, specifier: "%.1f") / 5.0")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // =======================
            // レビュー本文
            // =======================
            Section("レビュー") {
                TextEditor(text: $vm.comment)
                    .frame(height: 120)
            }

            // =======================
            // エラー表示
            // =======================
            if let error = vm.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
            }

            // =======================
            // 投稿ボタン
            // =======================
            Button {
                Task {
                    let success = await vm.submit(
                        animeId: animeId,
                        accessToken: accessToken
                    )
                    if success {
                        dismiss()
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    if vm.isSubmitting {
                        ProgressView()
                    } else {
                        Text("投稿する")
                            .fontWeight(.bold)
                    }
                    Spacer()
                }
            }
            if #available(iOS 26.0, *) {
                
            } else {
                // Fallback on earlier versions
            }
        }
        .navigationTitle("レビューを書く")
    }
}

