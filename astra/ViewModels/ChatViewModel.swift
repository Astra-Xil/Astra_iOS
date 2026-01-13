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
    private let threadId: UUID
    private let animeId: Int

    let currentUserId: UUID

    init(
        animeId: Int,
        threadId: UUID,
        userId: UUID,
        supabase: SupabaseClient
    ) {
        self.animeId = animeId
        self.threadId = threadId
        self.currentUserId = userId
        self.service = ChatBroadcastService(supabase: supabase)
    }

    // 初期ロード + Realtime 接続
    func onAppear(accessToken: String) async {

        await loadInitialMessages(accessToken: accessToken)

        try? await service.connect(threadId: threadId) { [weak self] bm in
            guard let self else { return }

            // thread フィルタ（保険）
            guard bm.threadId == self.threadId else { return }

            let message = ChatMessage(
                id: bm.id,
                animeId: bm.animeId,
                threadId: bm.threadId,
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
    func send(accessToken: String) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        text = ""

        do {
            let message = try await ChatServiceAPI.shared.postMessage(
                animeId: animeId,
                threadId: threadId,
                message: trimmed,
                accessToken: accessToken
            )

            messages.append(message)

            let broadcast = BroadcastMessage(from: message)
            try await service.send(message: broadcast)

        } catch {
            print("send error:", error)
        }
    }

    func loadInitialMessages(accessToken: String) async {
        do {
            let initial = try await ChatServiceAPI.shared.fetchMessages(
                threadId: threadId,
                accessToken: accessToken
            )

            self.messages = initial.sorted {
                $0.createdAt < $1.createdAt
            }

        } catch {
            print("fetch initial messages error:", error)
        }
    }

    func onDisappear() {
        Task { await service.disconnect() }
    }
}
