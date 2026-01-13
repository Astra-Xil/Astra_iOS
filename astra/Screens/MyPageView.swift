import SwiftUI
import PhotosUI
struct MyPageView: View {

@State private var selectedItem: PhotosPickerItem?
@State private var selectedImage: UIImage?
@State private var croppedImage: UIImage?
@State private var showCrop = false

var body: some View {
    VStack(spacing: 24) {

        if let image = croppedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 140)
                .clipShape(Circle())
        } else {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 140, height: 140)
        }

        PhotosPicker(selection: $selectedItem, matching: .images) {
            Text("画像を選択")
        }

        Spacer()
    }
    .padding()
    .onChange(of: selectedItem) {
        Task {
            if let data = try? await selectedItem?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedImage = uiImage
                showCrop = true
            }
        }
    }
    .sheet(isPresented: $showCrop) {
        if let image = selectedImage {
            AvatarCropView(image: image) { cropped in
                self.croppedImage = cropped
            }
        }
    }
}
}
