//
//  ChatPresenceService.swift
//  astra
//
//  Created by Xil on 2026/01/07.
//

import Foundation

import Supabase

final class ChatPresenceService {
  private let supabase: SupabaseClient
  private var channel: RealtimeChannelV2?
  private var onlineKeys = Set<String>()
  private var presenceSub: RealtimeSubscription?

  init(supabase: SupabaseClient) {
    self.supabase = supabase
  }

  func connect(
    animeId: Int,
    userId: UUID,
    onChange: @escaping @MainActor (Int) -> Void
  ) async throws {

    // 二重接続防止（超重要）
    await disconnect()

    let channel = supabase.realtimeV2.channel("chat:\(animeId):presence") {
      $0.presence.key = userId.uuidString
    }
    self.channel = channel

    // 先に presence の購読を登録（※ subscribe 前でもOK）
    self.presenceSub = channel.onPresenceChange { [weak self] action in
      guard let self else { return }

      // presence_state のときは joins に全員が載ってくることがあるので、まず joins を反映
      for key in action.joins.keys {
        self.onlineKeys.insert(key)
      }
      for key in action.leaves.keys {
        self.onlineKeys.remove(key)
      }

      Task { @MainActor in
        onChange(self.onlineKeys.count)
      }
    }

    try await channel.subscribeWithError()
    print("🟢 presence channel subscribed")

    // track は subscribe 後に
    await channel.track(state: [
      "userId": .string(userId.uuidString)
    ])

    // 自分を手動で insert しない（state に任せる）
  }

  func disconnect() async {
    presenceSub?.cancel()
    presenceSub = nil

    await channel?.untrack()
    await channel?.unsubscribe()
    channel = nil

    onlineKeys.removeAll()
  }
}
