//
//  AvatarCropView.swift
//  astra
//
//  Created by Xil on 2026/01/14.
//

import SwiftUI
import TOCropViewController

struct AvatarCropView: UIViewControllerRepresentable {

    let image: UIImage
    let onComplete: (UIImage) -> Void

    func makeUIViewController(context: Context) -> TOCropViewController {
        let vc = TOCropViewController(croppingStyle: .circular, image: image)
        vc.delegate = context.coordinator
        vc.aspectRatioLockEnabled = false
        vc.resetAspectRatioEnabled = false
        return vc
    }

    func updateUIViewController(_ uiViewController: TOCropViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onComplete: onComplete)
    }

    final class Coordinator: NSObject, TOCropViewControllerDelegate {
        let onComplete: (UIImage) -> Void

        init(onComplete: @escaping (UIImage) -> Void) {
            self.onComplete = onComplete
        }

        func cropViewController(_ cropViewController: TOCropViewController,
                                didCropTo image: UIImage,
                                with cropRect: CGRect,
                                angle: Int) {
            onComplete(image)
            cropViewController.dismiss(animated: true)
        }

        func cropViewController(_ cropViewController: TOCropViewController,
                                didFinishCancelled cancelled: Bool) {
            cropViewController.dismiss(animated: true)
        }
    }
}
