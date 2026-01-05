//
//  AniListSearchViewModels.swift
//  astra
//
//  Created by Xil on 2026/01/03.
//

import Combine
import Foundation
import Combine
import Foundation

enum AniListSearchState {
    case idle
    case loading
    case loaded([AniListSearchItem])
    case error(String)
}

import Foundation

@MainActor
final class AniListSearchViewModel: ObservableObject {

    @Published private(set) var state: AniListSearchState = .idle

    private let api: AniListSearchAPIProtocol

    // ✅ 依存性注入
    init(api: AniListSearchAPIProtocol) {
        self.api = api
    }

    func search(text: String) async {
        guard text.count >= 2 else {
            state = .idle
            return
        }

        state = .loading

        do {
            let items = try await api.search(query: text)
            state = .loaded(items)
        } catch {
            state = .error("検索に失敗しました")
        }
    }

    func reset() {
        state = .idle
    }
}
