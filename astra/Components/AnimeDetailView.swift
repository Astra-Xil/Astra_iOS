import SwiftUI

struct AnimeDetailView: View {
    let animeId: Int
    @StateObject private var vm = AnimeDetailViewModel()
    var body: some View {
        content
            .task(id: animeId) {
                await vm.load(id: animeId)
            }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {

        case .idle, .loading:
            ProgressView()

        case .loaded(let anime):
            AnimeHeader(anime: anime)

        case .error(let message):
            Text(message)
                .foregroundStyle(.red)
        }
    }
}

#Preview {
    AnimeDetailView(animeId: 21)
}

// MARK: - AnimeHeader
struct AnimeHeader: View {
    let anime: AnimeDetailUI

    var body: some View {
        HStack( spacing: 16) {
            AsyncImage(url: URL(string: anime.images.coverLarge ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 173, height: 244)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 8) {
                Text(anime.hero.statusText ?? "")
                    .font(.footnote)
                    .foregroundStyle(Color("PrimaryColor"))
                if let year = anime.meta.seasonYear {
                    Text(String(year))
                }

                Text(anime.title)
                    .font(.callout)
                    .fontWeight(.bold)
                

                Button {
                    // 投稿処理
                } label: {
                    Text("レビューを書く")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(width: 103, height: 30)
                        .background(
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color("PrimaryColor"))
                        )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
    }
}
