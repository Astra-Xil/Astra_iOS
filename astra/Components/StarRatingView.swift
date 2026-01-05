import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Double
    let maxRating: Int = 5
    let isEditable: Bool   // ← 追加
    let starSize: CGFloat      // ← 外から指定
    let spacing: CGFloat       // ← 外から指定

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
            isEditable
            ? DragGesture(minimumDistance: 0)
                .onChanged { value in
                    updateRating(from: value.location.x)
                }
            : nil
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
