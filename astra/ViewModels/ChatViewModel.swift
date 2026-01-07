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
    @Published var onlineCount: Int = 0

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
        try? await service.connect(
            animeId: animeId,
            userId: currentUserId,
            onMessage: { [weak self] bm in
                guard let self else { return }
                let message = ChatMessage(
                    id: bm.id,
                    animeId: bm.animeId,
                    content: bm.content,
                    createdAt: bm.createdAt,
                    userId: bm.userId,
                    profile: bm.profile.map { Profile(name: $0.name, avatarUrl: $0.avatarUrl) }
                )
                if !self.messages.contains(where: { $0.id == message.id }) {
                    self.messages.append(message)
                }
            },
            onPresenceChange: { [weak self] count in
                self?.onlineCount = count
            }
        )
    }

    // 自分の送信
    func send(accessToken: String) async {
        guard !text.isEmpty else { return }
        guard !accessToken.isEmpty else { return }
        let content = text
        text = ""

        do {
            // ① POST → 正のデータを受け取る
            let dto = try await ChatServiceAPI.shared.postMessage(
                animeId: animeId,
                message: content,
                accessToken: accessToken
            )

            // ② DTO → UIモデル
            let message = ChatMessage(
                id: dto.id,
                animeId: dto.animeId,
                content: dto.content,
                createdAt: dto.createdAt,
                userId: dto.userId,
                profile: dto.profiles
            )

            // ③ UI反映
            messages.append(message)

            // ④ Broadcast（コピーを配るだけ）
            let broadcast = BroadcastMessage(
                id: message.id,
                animeId: message.animeId,
                content: message.content,
                createdAt: message.createdAt,
                userId: message.userId,
                profile: message.profile.map {
                    BroadcastProfile(
                        name: $0.name,
                        avatarUrl: $0.avatarUrl
                    )
                }
            )

            try await service.send(message: broadcast)

        } catch {
            print("send error:", error)
        }
    }

    func loadInitialMessages(accessToken: String) async {
        do {
            let initial = try await ChatServiceAPI.shared.fetchInitialMessages(
                animeId: animeId,
                accessToken: accessToken
            )

            // 並び保証（念のため）
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
