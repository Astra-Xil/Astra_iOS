//
//  ChatViewModel.swift
//  astra
//
//  Created by Xil on 2026/01/06.
//
import Combine
import Supabase
import Foundation
@MainActor
final class ChatViewModel: ObservableObject {

    @Published var messages: [ChatMessage] = []
        @Published var text: String = ""

        private let service: ChatBroadcastService
        private let animeId: Int
        private let userName: String

        // 👇 View から読む用（読み取り専用）
        var currentUserName: String {
            userName
        }

        init(
            animeId: Int,
            userName: String,
            supabase: SupabaseClient
        ) {
            self.animeId = animeId
            self.userName = userName
            self.service = ChatBroadcastService(supabase: supabase)
        }

    func onAppear() async {
        try? await service.connect(animeId: animeId) { [weak self] msg in
            guard let self else { return }

            Task { @MainActor in
                self.messages.append(msg)
            }
        }
    }


    func send() async {
        guard !text.isEmpty else { return }

        let message = ChatMessage(
            id: UUID(),
            animeId: animeId,
            content: text,
            userName: userName,
            createdAt: String()
        )

        text = ""

        do {
            try await service.send(message: message)
        } catch {
            print("send error:", error)
        }
    }



    func onDisappear() {
        Task {
            await service.disconnect()
        }
    }

}
