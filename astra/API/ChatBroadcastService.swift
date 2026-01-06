import Foundation

import Supabase

final class ChatBroadcastService {

    private let supabase: SupabaseClient
    private var channel: RealtimeChannelV2?

    init(supabase: SupabaseClient) {
        self.supabase = supabase
    }

    // MARK: - 接続
    func connect(
        animeId: Int,
        onMessage: @escaping @MainActor (ChatMessage) -> Void
    ) async throws {

        let channel = supabase.realtimeV2.channel("chat:\(animeId)") {
            $0.broadcast.receiveOwnBroadcasts = true
        }
        self.channel = channel

        // ① subscribe
        try await channel.subscribeWithError()
        print("🟢 subscribed chat:\(animeId)")

        // ② stream
        let stream = channel.broadcastStream(event: "message")

        Task {
            for await rawEvent in stream {
                do {
                    print("📩 raw event:", rawEvent)

                    guard let payload = rawEvent["payload"] else {
                        print("❌ no payload")
                        continue
                    }

                    // ✅ AnyJSON → Data（公式に保証されている）
                    let data = try JSONEncoder().encode(payload)

                    // ✅ Data → ChatMessage
                    let msg = try JSONDecoder().decode(ChatMessage.self, from: data)

                    await onMessage(msg)

                } catch {
                    print("❌ decode error:", error)
                }
            }
        }


    }


    // MARK: - 送信
    func send(message: ChatMessage) async throws {
        guard let channel else { return }
        try await channel.broadcast(
            event: "message",
            message: message
        )
    }

    // MARK: - 切断
    func disconnect() async {
        await channel?.unsubscribe()
        channel = nil
    }
}
