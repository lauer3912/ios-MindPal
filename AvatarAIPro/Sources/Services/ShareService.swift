import UIKit
import Photos

final class ShareService {

    static let shared = ShareService()

    private init() {}

    // MARK: - Share Methods

    func shareToTikTok(image: UIImage, from viewController: UIViewController) {
        // TikTok sharing via URL scheme
        let instagramURL = URL(string: "instagram-stories://share?source_application=com.ggsheng.AvatarAIPro")!

        if UIApplication.shared.canOpenURL(instagramURL) {
            shareToInstagramStories(image: image)
        } else {
            // Fallback to generic share sheet
            shareGeneric(image: image, from: viewController)
        }
    }

    func shareToInstagramStories(image: UIImage) {
        guard let imageData = image.pngData() else { return }

        let pasteboardItems: [String: Any] = [
            "com.instagram.sharedSticker.backgroundImage": imageData
        ]

        let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [
            .expirationDate: Date().addingTimeInterval(60 * 5)
        ]

        UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)

        let instagramURL = URL(string: "instagram-stories://share?source_application=com.ggsheng.AvatarAIPro")!
        UIApplication.shared.open(instagramURL)
    }

    func shareToInstagramFeed(image: UIImage, from viewController: UIViewController) {
        guard let imageData = image.pngData() else { return }

        let pasteboardItems: [String: Any] = [
            "com.instagram.media": imageData
        ]

        let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [
            .expirationDate: Date().addingTimeInterval(60 * 5)
        ]

        UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)

        let instagramURL = URL(string: "instagram://app")!
        if UIApplication.shared.canOpenURL(instagramURL) {
            UIApplication.shared.open(instagramURL)
        } else {
            shareGeneric(image: image, from: viewController)
        }
    }

    func shareGeneric(image: UIImage, from viewController: UIViewController) {
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )

        // For iPad
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        viewController.present(activityViewController, animated: true)
    }

    // MARK: - Save to Photos

    func saveToPhotos(image: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    completion(true, nil)
                case .denied, .restricted:
                    completion(false, ShareError.photoLibraryAccessDenied)
                case .notDetermined:
                    completion(false, ShareError.photoLibraryAccessDenied)
                @unknown default:
                    completion(false, ShareError.photoLibraryAccessDenied)
                }
            }
        }
    }

    // MARK: - Errors

    enum ShareError: LocalizedError {
        case photoLibraryAccessDenied

        var errorDescription: String? {
            switch self {
            case .photoLibraryAccessDenied:
                return "Photo library access denied. Please enable it in Settings."
            }
        }
    }
}
