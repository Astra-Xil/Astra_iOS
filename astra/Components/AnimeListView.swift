//
//  AnimeListView.swift
//  astra
//
//  Created by Xil on 2025/12/21.
//

import SwiftUI

struct AnimeListView: View {
    let title: String
    @State var showChat: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // セクションタイトル
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            // 横スクロール
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(0..<7) { _ in
                        NavigationLink {
                            AnimeDetailScreenView(
                                animeId: 12, title: "タコピーの原罪"
                                                        )
                        } label: {
                            AnimeCardView(title: "タコピーの原罪", genres: [""], imageUrl: "")
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
