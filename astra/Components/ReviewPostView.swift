import SwiftUI

struct ReviewPostView: View {

    let animeId: Int
    let accessToken: String

    @StateObject private var vm = ReviewPostViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {

        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                Text("レビューを書く")
                    .font(.title)
                    .fontWeight(.semibold)

                HStack {
                    Text("タップして評価：")
                        .font(.footnote)
                        .foregroundStyle(Color("SecondaryColor"))

                    Spacer()

                    StarRatingView(rating: $vm.score)
                }
                .padding(.leading, 12)

                // =======================
                // レビュー本文
                // =======================
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("レビュー")
                        .font(.title3)
                        .fontWeight(.semibold)

                    DynamicHeightTextEditor(text: $vm.comment, placeholder: "任意", minHeight: 120, maxHeight: 360)
    
                }
                // =======================
                // エラー表示
                // =======================
                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 8) // ヘッダー分の余白
        }
        .safeAreaInset(edge: .top) {
            header   // ← ここで固定
        }
    }

    // =======================
    // 固定ヘッダー
    // =======================
    private var header: some View {
        HStack {
            if #available(iOS 26.0, *) {
                Button {
                    //閉じる処理
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundStyle(Color("PrimaryColor"))
                        .frame(width: 48, height: 48)
                }
                .glassEffect(.regular)
            }

            Spacer()

            if #available(iOS 26.0, *) {
                Button {
                    // 投稿処理
                } label: {
                    Image(systemName: "arrow.up")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .frame(width: 48, height: 48)
                }
                .glassEffect(.regular.tint(Color("PrimaryColor")))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
    }
}

#Preview {
    NavigationStack {
        ReviewPostView(
            animeId: 1,
            accessToken: "preview-token"
        )
    }
}

