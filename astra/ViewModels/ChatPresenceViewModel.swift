//
//  ChatPresenceViewModel.swift
//  astra
//
//  Created by Xil on 2026/01/07.
//
import Combine
import Supabase
import Foundation
@MainActor
final class ChatPresenceViewModel: ObservableObject {

    @Published var onlineCount: Int = 0

    private let service: ChatPresenceService
    private let threadId: UUID
    private let userId: UUID

    init(
        threadId: UUID,
        userId: UUID,
        supabase: SupabaseClient
    ) {
        self.threadId = threadId
        self.userId = userId
        self.service = ChatPresenceService(supabase: supabase)
    }

    func start() async {
        try? await service.connect(
            threadId: threadId,
            userId: userId
        ) { [weak self] count in
            self?.onlineCount = count
        }
    }

    func stop() async {
        await service.disconnect()
    }
}
