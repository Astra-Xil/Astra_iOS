import SwiftUI

struct AnimeSearchView: View {

    @StateObject private var vm = AnimeSearchViewModel()
    @State private var query = ""
    @EnvironmentObject var authStore: AuthStore

    // ✅ 常に3列
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 16),
        count: 3
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                if vm.isLoading {
                    ProgressView()
                        .padding(.top, 40)
                }

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(vm.result) { item in
                        NavigationLink {
                                ReviewPostView(animeId: item.id,accessToken: authStore.accessToken)
                            } label: {
                                AnimeCardView(
                                    title: item.title,
                                    genres: item.genres,
                                    imageUrl: item.imageUrl
                                )
                            }
                            .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .navigationTitle("検索")
        }
        .searchable(text: $query)
        .onSubmit(of: .search) {
            Task {
                await vm.loadAnime(q: query)
            }
        }
    }
}
