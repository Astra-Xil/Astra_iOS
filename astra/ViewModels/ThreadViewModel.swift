//
//  ThreadViewModel.swift
//  astra
//
//  Created by Xil on 2026/01/13.
//

import Combine
import Foundation
@MainActor
final class ThreadViewModel: ObservableObject {

    @Published var threads: [ThreadItem] = []
    @Published var titleText: String = ""

    let animeId: Int

    init(animeId: Int) {
        self.animeId = animeId
    }

    func load() async {
        do {
            threads = try await ThreadServiceAPI.shared.fetchThreads(animeId: animeId)
        } catch {
            print("load threads error:", error)
        }
    }

    func create(accessToken: String) async {
        let trimmed = titleText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        do {
            let new = try await ThreadServiceAPI.shared.createThread(
                animeId: animeId,
                title: trimmed,
                accessToken: accessToken
            )
            threads.insert(new, at: 0)
            titleText = ""
        } catch {
            print("create thread error:", error)
        }
    }
}

