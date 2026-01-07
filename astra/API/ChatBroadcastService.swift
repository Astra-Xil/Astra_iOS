import Foundation

import Supabase

final class ChatBroadcastService {

    private let supabase: SupabaseClient
    private var channel: RealtimeChannelV2?

    // Presence の人数を自前で保持
    private var onlineKeys = Set<String>()   // presence.key（= userId.uuidString）を入れる

    init(supabase: SupabaseClient) {
        self.supabase = supabase
    }

    func connect(
        animeId: Int,
        userId: UUID,
        onMessage: @escaping @MainActor (BroadcastMessage) -> Void,
        onPresenceChange: @escaping @MainActor (Int) -> Void
    ) async throws {

        let channel = supabase.realtimeV2.channel("chat:\(animeId)") {
            $0.presence.key = userId.uuidString
            $0.broadcast.receiveOwnBroadcasts = true
        }
        self.channel = channel

        // subscribe
        try await channel.subscribeWithError()
        print("🟢 subscribed chat:\(animeId)")

        // ✅ track（オンライン宣言）
        await channel.track(state: [
            "userId": .string(userId.uuidString)
        ])

        // ✅ presence change（joins/leaves を監視して数える）
        let presenceStream = channel.presenceChange()
        Task { [weak self] in
            guard let self else { return }

            // 自分は online 扱い
            self.onlineKeys.insert(userId.uuidString)
            await onPresenceChange(self.onlineKeys.count)

            for await action in presenceStream {
                // joins/leaves は辞書で来る（キーが presence.key）
                for key in action.joins.keys {
                    self.onlineKeys.insert(key)
                }
                for key in action.leaves.keys {
                    self.onlineKeys.remove(key)
                }
                await onPresenceChange(self.onlineKeys.count)
            }
        }

        // ✅ Broadcast（今まで通り）
        let stream = channel.broadcastStream(event: "message")
        Task {
            for await rawEvent in stream {
                do {
                    guard let payload = rawEvent["payload"] else { continue }

                    let data = try JSONEncoder().encode(payload)

                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601   // まずは iso8601でOK（必要ならあなたのcustomに戻す）

                    let msg = try decoder.decode(BroadcastMessage.self, from: data)
                    await onMessage(msg)

                } catch {
                    print("❌ decode error:", error)
                }
            }
        }
    }

    func send(message: BroadcastMessage) async throws {
        guard let channel else { return }
        try await channel.broadcast(event: "message", message: message)
    }

    func disconnect() async {
        await channel?.untrack()
        await channel?.unsubscribe()
        channel = nil
        onlineKeys.removeAll()
    }
}
