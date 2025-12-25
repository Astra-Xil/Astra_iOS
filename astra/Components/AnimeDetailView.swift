import SwiftUI

struct AnimeDetailView: View {
    let animeId: Int
    @StateObject private var vm = AnimeDetailViewModel()

    var body: some View {
        VStack(spacing: 12) {

            if vm.isLoading {
                ProgressView()
            }

            if let anime = vm.anime {
                Text(anime.title)
                    .font(.title)

                Text(anime.hero.scoreText)
                    .font(.caption)

                Text(anime.synopsis)
                    .font(.footnote)
                    .lineLimit(5)
            }

            if let errorMessage = vm.errorMessage {
                            Text(errorMessage)
                                .foregroundStyle(.red)
                        }
        }
        .padding()
        .task(id: animeId) {
            await vm.load(id: animeId)
        }
    }
}
#Preview {
    AnimeDetailView(animeId: 14333)
}
