import SwiftUI
import SimpleToast
struct AnimeDetailScreenView: View {
    let animeId: Int
    let title: String
    @State private var showChat = false
    var body: some View {
        NavigationStack {
            AnimeDetailView(
                animeId: animeId
            )
        }
        .navigationTitle("詳細")

        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showChat = true
                } label: {
                    Label("Chat", systemImage: "bubble.left")
                }
            }
        }
        .sheet(isPresented: $showChat) {
            NavigationStack {
                    ReviewPostView(
                        animeId: animeId
                    )
                }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        
    }
}
#Preview {
    AnimeDetailScreenView(animeId: 11, title: "")
}
