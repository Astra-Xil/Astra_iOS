import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Double
    let maxRating: Int = 5

    private let starSize: CGFloat = 20
    private let spacing: CGFloat = 4

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                    .font(.system(size: starSize))
                    .foregroundStyle(Color("PrimaryColor"))
                    .contentShape(Rectangle()) // ★ タップ範囲を広げる
                    .onTapGesture {
                        rating = Double(index)
                    }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    updateRating(from: value.location.x)
                }
        )
        .animation(.easeInOut(duration: 0.15), value: rating)
    }

    // MARK: - Drag で一気に変更できるようにする
    private func updateRating(from x: CGFloat) {
        let unitWidth = starSize + spacing
        let raw = Int(x / unitWidth) + 1
        let newRating = min(max(raw, 1), maxRating)
        rating = Double(newRating)
    }
}
