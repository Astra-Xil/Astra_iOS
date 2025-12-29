import SwiftUI
import SimpleToast
struct AnimeDetailScreenView: View {

    let title: String
    @State private var showChat = false
    var body: some View {
        NavigationStack {
            AnimeDetailView(
                animeId: 21
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
                        animeId: 3
                    )
                }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        
    }
}
#Preview {
    AnimeDetailScreenView(title: "")
}
