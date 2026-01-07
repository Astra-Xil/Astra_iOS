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
        onMessage: @escaping @MainActor (BroadcastMessage) -> Void
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

                    let data = try JSONEncoder().encode(payload)

                    let decoder = JSONDecoder()

                    let formatterWithTZ = ISO8601DateFormatter()
                    formatterWithTZ.formatOptions = [
                        .withInternetDateTime,
                        .withFractionalSeconds
                    ]

                    let formatterNoTZ = DateFormatter()
                    formatterNoTZ.locale = Locale(identifier: "en_US_POSIX")
                    formatterNoTZ.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

                    decoder.dateDecodingStrategy = .custom { decoder in
                        let container = try decoder.singleValueContainer()
                        let value = try container.decode(String.self)

                        // ① タイムゾーン付き（理想）
                        if let date = formatterWithTZ.date(from: value) {
                            return date
                        }

                        // ② タイムゾーン無し（今回）
                        if let date = formatterNoTZ.date(from: value) {
                            return date
                        }

                        throw DecodingError.dataCorruptedError(
                            in: container,
                            debugDescription: "Invalid date format: \(value)"
                        )
                    }


                    let msg = try decoder.decode(BroadcastMessage.self, from: data)
                    await onMessage(msg)

                } catch {
                    print("❌ decode error:", error)
                }
            }
        }



    }


    // MARK: - 送信
    func send(message: BroadcastMessage) async throws {
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
