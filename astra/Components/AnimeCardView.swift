import SwiftUI

struct AnimeCardView: View {

    let title: String
    let genres: [String]
    let imageUrl: String

    @EnvironmentObject var screenSizeStore: ScreenSizeStore

    private let spacing: CGFloat = 24
    private let horizontalPadding: CGFloat = 16

    var body: some View {

        let totalWidth = screenSizeStore.screenWidth - horizontalPadding * 2
        let cardWidth = max((totalWidth - spacing * 2) / 3, 0)
        let cardHeight = cardWidth * (195.0 / 130.0)

        VStack(alignment: .leading, spacing: 2) {

            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: cardWidth, height: cardHeight)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .clipped()

            Text(title)
                .font(.caption2)
                .lineLimit(1)

            Text(genres.joined(separator: " / "))
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .opacity(cardWidth > 0 ? 1 : 0) // 初期0対策
    }
}
