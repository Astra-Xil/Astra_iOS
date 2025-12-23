import SwiftUI

struct ContentView: View {
    
    @StateObject private var auth = AuthViewModel()
    @EnvironmentObject var screenSizeStore: ScreenSizeStore
    var body: some View {
        GeometryReader { rootViewGeometry in
            Group {
                if !auth.checked {
                    ProgressView()
                } else if auth.isLoggedIn {
                    MainTabView()
                } else {
                    LoginView()
                }
            }
            .task {
                await auth.checkLoginStatus()
            }
            .environmentObject(auth)
            .onAppear {
                screenSizeStore.update(width: rootViewGeometry.size.width, height: rootViewGeometry.size.height)
            }
            .onChange(of: rootViewGeometry.size) { updatedValue in
                screenSizeStore.update(width: updatedValue.width, height: updatedValue.height)
            }
        }
    }
}
