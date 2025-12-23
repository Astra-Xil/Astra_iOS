import Foundation
import Supabase
import Combine

@MainActor
final class AuthStore: ObservableObject {

    @Published var session: Session?

    private let supabase = SupabaseManager.shared.client

    init() {
        Task {
            await loadSession()
        }
    }

    var accessToken: String {
        session?.accessToken ?? ""
    }

    func loadSession() async {
        do {
            session = try await supabase.auth.session
        } catch {
            session = nil
            print("Failed to load session:", error)
        }
    }

    func refreshSession() async {
        do {
            session = try await supabase.auth.session
        } catch {
            session = nil
            print("Failed to refresh session:", error)
        }
    }

    func signOut() async throws {
        try await supabase.auth.signOut()
        session = nil
    }
}
