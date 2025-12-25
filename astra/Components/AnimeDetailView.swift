import SwiftUI

struct AnimeDetailView: View {
    let title: String

    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 16) {

                Image("Takopi")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()

                Text(title)
                    .font(.title)
                    .fontWeight(.bold)

                Text("ここに作品の詳細を書く")
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
}
