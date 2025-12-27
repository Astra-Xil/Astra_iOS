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

