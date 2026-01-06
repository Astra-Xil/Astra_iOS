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

    let currentUserId: UUID   // ← ここが基準

    init(
            animeId: Int,
            userId: UUID,
            supabase: SupabaseClient
        ) {
            self.animeId = animeId
            self.currentUserId = userId
            self.service = ChatBroadcastService(supabase: supabase)
        }
    // 他人からの Broadcast を受信
    func onAppear() async {
        try? await service.connect(animeId: animeId) { [weak self] bm in
            guard let self else { return }

            let message = ChatMessage(
                id: bm.id,
                animeId: bm.animeId,
                content: bm.content,
                createdAt: bm.createdAt,
                userId: bm.userId,
                profile: bm.profile.map {
                    Profile(name: $0.name, avatarUrl: $0.avatarUrl)
                }
            )

            if !self.messages.contains(where: { $0.id == message.id }) {
                        self.messages.append(message)
                    }
        }
    }

    // 自分の送信
    func send() async {
        guard !text.isEmpty else { return }

        let now = Date()

        // UI 用の正体
        let chatMessage = ChatMessage(
            id: UUID(),
            animeId: animeId,
            content: text,
            createdAt: now,
            userId: currentUserId, // 本当は session.user.id
            profile: nil
        )

        // 即 UI 反映
        messages.append(chatMessage)
        text = ""

        // Broadcast 用の軽量モデル
        let broadcast = BroadcastMessage(
            id: chatMessage.id,
            animeId: chatMessage.animeId,
            content: chatMessage.content,
            createdAt: chatMessage.createdAt,
            userId: chatMessage.userId,
            profile: nil
        )

        do {
            try await service.send(message: broadcast)
        } catch {
            print("send error:", error)
        }
    }

    func onDisappear() {
        Task { await service.disconnect() }
    }
}
