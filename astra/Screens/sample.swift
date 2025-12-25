//import SwiftUI
//import SimpleToast
//
//struct ToastTestView: View {
//    @State private var showToast = false
//
//    private let toastOptions = SimpleToastOptions(
//        hideAfter: 2,
//        displayMode: .full
//    )
//    var body: some View {
//        VStack {
//            Button("Show toast") {
//                withAnimation {
//                    showToast.toggle()
//                }
//            }
//        }
//        .simpleToast(isPresented: $showToast, options: toastOptions) {
//            if #available(iOS 26.0, *) {
//                Label("This is some simple toast message.", systemImage: "exclamationmark.triangle")
//                    .padding()
//                    .foregroundColor(Color.white)
//                    .glassEffect(.regular.tint(Color("PrimaryColor")))
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//    }
//}
//#Preview() {
//    ToastTestView()
//        .environmentObject(ScreenSizeStore())
//}
import SwiftUI

struct Sample: View {
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
    Sample(animeId: 21)
}
