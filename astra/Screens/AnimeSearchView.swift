import SwiftUI
import Supabase

struct AnimeSearchView: View {

    @StateObject private var vm =
            AniListSearchViewModel(api: AniListSearchAPI())
    @State private var query = ""

    var body: some View {
        NavigationStack {
            content
                
        }
        .navigationTitle("検索")
        .searchable(text: $query)
        .onSubmit(of: .search) {
            Task {
                await vm.search(text: query)
            }
        }
    }

    // MARK: - State Rendering
    @ViewBuilder
    private var content: some View {
        switch vm.state {

        case .idle:
            VStack {
                Spacer()
                Text("作品名で検索してください")
                    .foregroundStyle(.secondary)
                Spacer()
            }

        case .loading:
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }

        case .loaded(let items):
            if items.isEmpty {
                VStack {
                    Spacer()
                    Text("該当する作品がありません")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            } else {
                List(items) { item in
                    NavigationLink {
                        ThreadListView(animeId: item.id)
                    } label: {
                        AnimeRowView(item: item)
                    }
                    .listRowSeparator(.visible)
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                    
                }
                .listStyle(.plain)
            }

        case .error(let message):
            VStack {
                Spacer()
                Text(message)
                    .foregroundColor(.red)
                Spacer()
            }
        }
    }
}

struct AnimeRowView: View {

    let item: AniListSearchItem   // ← vm.search の型に合わせて

    var body: some View {
        HStack(spacing: 12) {

            // 画像（あるなら）
            AsyncImage(url: URL(string: item.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 80, height: 113)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline)
                    .lineLimit(2)

                Text(item.genres.joined(separator: " / "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            
        }
        .padding(.vertical, 2)
    }
}

