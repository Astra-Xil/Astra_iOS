//
//  AnimeHeader.swift
//  astra
//
//  Created by Xil on 2025/12/27.
//
import SwiftUI
struct AnimeHeader: View {
    let anime: AnimeDetailUI

    var body: some View {
        HStack(spacing: 8) {
            AsyncImage(url: URL(string: anime.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 195, height: 280)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 8) {
                Text(anime.hero.statusLabel)
                    .font(.caption)

                Text(anime.title)
                    .font(.title)

                Button {
                    // 投稿処理
                } label: {
                    Text("レビューを書く")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 140)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color("PrimaryColor"))
                        )
                }
            }
        }
    }
}
