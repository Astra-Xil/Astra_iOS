import SwiftUI

struct AnimeCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Image("Takopi") // Assetsに入れた画像名
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 195) // ← 縦長
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .clipped()
            VStack(alignment: .leading, spacing: 2) {
                Text("タコピーの原罪")
                    .font(.footnote)
                    .lineLimit(2)
                HStack(spacing: 4) {
                    Text("SF")
                    Text("Drama")
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
            }
            
        }
        
    }
}
