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
    private let animeId: Int
    private let userId: UUID

    init(
        animeId: Int,
        userId: UUID,
        supabase: SupabaseClient
    ) {
        self.animeId = animeId
        self.userId = userId
        self.service = ChatPresenceService(supabase: supabase)
    }

    func start() async {
        try? await service.connect(
            animeId: animeId,
            userId: userId
        ) { [weak self] count in
            self?.onlineCount = count
        }
    }

    func stop() async {
        await service.disconnect()
    }
}
