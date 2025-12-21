import SwiftUI

struct ContentView: View {

  @StateObject private var auth = AuthViewModel()

  var body: some View {
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
  }
}
