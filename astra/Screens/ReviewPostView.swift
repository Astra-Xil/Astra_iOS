import SwiftUI

struct ReviewPostView: View {

    let animeId: Int
    let accessToken: String

    @StateObject private var vm = ReviewPostViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("評価") {
                Slider(value: $vm.score, in: 1...5, step: 0.5)
                Text("⭐️ \(vm.score, specifier: "%.1f")")
            }

            Section("レビュー") {
                TextEditor(text: $vm.comment)
                    .frame(height: 120)
            }

            if let error = vm.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
            }

            Button {
                Task {
                    let success = await vm.submit(
                        animeId: animeId,
                        accessToken: accessToken
                    )
                    if success {
                        dismiss() // ← 投稿成功後に自動で戻る
                    }
                }
            } label: {
                if vm.isSubmitting {
                    ProgressView()
                } else {
                    Text("投稿する")
                }
            }
        }
        .navigationTitle("レビューを書く")
    }
}
