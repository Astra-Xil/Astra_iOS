//
//  astraApp.swift
//  astra
//
//  Created by Xil on 2025/12/21.
//

import SwiftUI
import Supabase
@main
struct astraApp: App {
    @StateObject private var authStore = AuthStore()
    let supabase = SupabaseManager.shared.client
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ScreenSizeStore())
                .environmentObject(authStore)
                .environment(\.supabase, supabase)
        }
        
    }
}

private struct SupabaseKey: EnvironmentKey {
    static let defaultValue: SupabaseClient =
        SupabaseManager.shared.client
}

extension EnvironmentValues {
    var supabase: SupabaseClient {
        get { self[SupabaseKey.self] }
        set { self[SupabaseKey.self] = newValue }
    }
}
