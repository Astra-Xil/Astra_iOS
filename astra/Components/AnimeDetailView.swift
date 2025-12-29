import SwiftUI

struct AnimeDetailView: View {
    let animeId: Int
    @StateObject private var vm = AnimeDetailViewModel()
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                content
            }
            .padding()
        }
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
