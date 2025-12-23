import SwiftUI

struct AnimeSearchView: View {

    @StateObject private var vm = AnimeSearchViewModel()
    @State private var query = ""

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
                        AnimeCardView(
                            title: item.title,
                            genres: item.genres,
                            imageUrl: item.imageUrl
                        )
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
