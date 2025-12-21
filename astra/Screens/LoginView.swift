import SwiftUI

struct LoginView: View {

  @EnvironmentObject var auth: AuthViewModel

  var body: some View {
    VStack {
      Button("Googleでログイン") {
        Task {
          await auth.signInWithGoogle()
        }
      }
    }
  }
}
