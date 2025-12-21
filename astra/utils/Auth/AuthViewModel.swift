import Foundation
import Supabase
import Combine 
@MainActor
final class AuthViewModel: ObservableObject {

  @Published var isLoggedIn = false
  @Published var checked = false

  func checkLoginStatus() async {
    do {
      let session = try await SupabaseManager.shared.client.auth.session
      isLoggedIn = !session.isExpired
    } catch {
      isLoggedIn = false
    }
    checked = true
  }

  func signInWithGoogle() async {
    do {
      try await SupabaseManager.shared.client.auth.signInWithOAuth(
        provider: .google,
        redirectTo: URL(string: "myapp://auth-callback")!
      )
      await checkLoginStatus()
    } catch {
      print("login error:", error)
    }
  }
}
