////
////  ChatGetViewModel.swift
////  astra
////
////  Created by Xil on 2026/01/06.
////
//import Combine
//import Foundation
//import Supabase
//@MainActor
//final class ChatGetViewModel: ObservableObject {
//
//    @Published var messages: [ChatMessage] = []
//
//    private let animeId: Int
//    private let accessToken: String
//    private let supabase: SupabaseClient
//    private let realtime: ChatRealtimeService
//
//    private var profileCache: [UUID: Profile] = [:]
//
//    init(
//        animeId: Int,
//        accessToken: String,
//        supabase: SupabaseClient
//    ) {
//        self.animeId = animeId
//        self.accessToken = accessToken
//        self.supabase = supabase
//        self.realtime = ChatRealtimeService(client: supabase)
//    }
//
//    func onAppear() {
//        Task {
//            await loadInitial()
//            subscribeRealtime()
//        }
//    }
//
//    func onDisappear() {
//        realtime.unsubscribe()
//    }
//
//    private func loadInitial() async {
//        do {
//            let initial = try await ChatServiceAPI.shared
//                .fetchInitialMessages(
//                    animeId: animeId,
//                    accessToken: accessToken
//                )
//
//            messages = initial
//
//            for m in initial {
//                if let profile = m.profile {
//                    profileCache[m.userId] = profile
//                }
//            }
//        } catch {
//            print("initial load error:", error)
//        }
//    }
//
//    private func subscribeRealtime() {
//        realtime.subscribe(animeId: animeId) { [weak self] dto in
//            Task { await self?.handleRealtime(dto) }
//        }
//    }
//
//    private func handleRealtime(_ dto: ChatMessageDTO) async {
//        if messages.contains(where: { $0.id == dto.id }) {
//            return
//        }
//
//        var msg = ChatMessage(
//            id: dto.id,
//            animeId: dto.animeId,
//            content: dto.content,
//            createdAt: dto.createdAt,
//            userId: dto.userId,
//            profile: nil
//        )
//
//        if let cached = profileCache[dto.userId] {
//            msg.profile = cached
//        } else if let profile = try? await fetchProfile(userId: dto.userId) {
//            profileCache[dto.userId] = profile
//            msg.profile = profile
//        }
//
//        messages.append(msg)
//    }
//
//    private func fetchProfile(userId: UUID) async throws -> Profile {
//        try await supabase
//            .from("profiles")
//            .select()
//            .eq("id", value: userId)
//            .single()
//            .execute()
//            .value
//    }
//}
