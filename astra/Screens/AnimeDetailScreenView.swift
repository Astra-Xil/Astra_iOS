import SwiftUI
import SimpleToast
struct AnimeDetailScreenView: View {
    let animeId: Int
    let title: String
    @State private var showChat = false
    var body: some View {
        
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading,spacing: 12) {
                        AnimeDetailView(animeId: animeId)
                        ReviewSectionView(animeId: animeId)
                    }
                    .padding(.horizontal)
                }
                .ignoresSafeArea(.container, edges: .horizontal)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if #available(iOS 26.0, *) {
                            NavigationLink {
                                ChatView(animeId: animeId)
                            } label: {
                                Image(systemName: "bubble.left")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 64, height: 64)
                                    .background(Color("PrimaryColor"))
                                    .clipShape(Circle())
                            }
                            .glassEffect(.regular.tint(Color("PrimaryColor")).interactive())
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 20)
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
