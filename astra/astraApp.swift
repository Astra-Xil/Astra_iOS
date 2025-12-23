//
//  astraApp.swift
//  astra
//
//  Created by Xil on 2025/12/21.
//

import SwiftUI

@main
struct astraApp: App {
    @StateObject private var authStore = AuthStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ScreenSizeStore())
                .environmentObject(authStore)
        }
        
    }
}
