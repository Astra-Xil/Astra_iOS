//
//  ChatPostViewModel.swift
//  astra
//
//  Created by Xil on 2026/01/06.
//

import Foundation
import Combine

@MainActor
final class ChatPostViewModel: ObservableObject {

    @Published var message: String = ""
    @Published var isSubmitting = false
    @Published var errorMessage: String?

    func submit(
        animeId: Int,
        accessToken: String
    ) async -> Bool {

        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        do {
            try await ChatServiceAPI.shared.postMessage(
                animeId: animeId,   // ← Int のまま
                message: message,
                accessToken: accessToken
            )
            return true

        } catch let error as NSError {
            errorMessage = error.localizedDescription
            return false

        } catch {
            errorMessage = "通信エラーが発生しました"
            return false
        }
    }
}
