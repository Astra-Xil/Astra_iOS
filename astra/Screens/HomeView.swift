import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    AnimeListView(title: "おすすめ")
                    AnimeListView(title: "話題の作品")
                    AnimeListView(title: "今期アニメ")
                }
                .padding(.top)
            }
            .navigationTitle("ホーム")
        }
    }
}
