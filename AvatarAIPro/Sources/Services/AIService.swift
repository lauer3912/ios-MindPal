import Foundation
import UIKit

protocol AIServiceProtocol {
    func generateAvatar(from image: UIImage, style: Style, completion: @escaping (Result<UIImage, Error>) -> Void)
}

enum AIServiceError: LocalizedError {
    case invalidImage
    case generationFailed
    case networkError
    case insufficientCredits
    case noFaceDetected

    var errorDescription: String? {
        switch self {
        case .invalidImage: return "Invalid image provided"
        case .generationFailed: return "Avatar generation failed. Please try again."
        case .networkError: return "Network error. Please check your connection."
        case .insufficientCredits: return "Insufficient credits"
        case .noFaceDetected: return "No face detected in the image. Please upload a clear selfie."
        }
    }
}

final class AIService: AIServiceProtocol {

    static let shared = AIService()

    private init() {}

    // MARK: - Public Methods

    func generateAvatar(from image: UIImage, style: Style, completion: @escaping (Result<UIImage, Error>) -> Void) {
        // For MVP: Simulate AI generation with sample images
        // In production, this would call Replicate/Stable Diffusion API

        DispatchQueue.global().async {
            // Simulate network delay
            Thread.sleep(forTimeInterval: 2.0)

            // For now, return a tinted version of the original image as placeholder
            // In real implementation, this would call AI API
            let resultImage = self.applyStyle(to: image, style: style)

            DispatchQueue.main.async {
                completion(.success(resultImage))
            }
        }
    }

    func detectFace(in image: UIImage, completion: @escaping (Bool) -> Void) {
        // For MVP: Always return true
        // In production, use Vision framework for face detection
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.5)
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }

    // MARK: - Private Methods

    private func applyStyle(to image: UIImage, style: Style) -> UIImage {
        // Placeholder: Apply a color filter to simulate styling
        guard let ciImage = CIImage(image: image) else { return image }

        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)

        switch style.id {
        case "anime":
            filter?.setValue(1.2, forKey: kCIInputSaturationKey)
            filter?.setValue(0.0, forKey: kCIInputContrastKey)
        case "cyberpunk":
            filter?.setValue(1.5, forKey: kCIInputSaturationKey)
            filter?.setValue(1.3, forKey: kCIInputContrastKey)
        case "portrait":
            filter?.setValue(1.1, forKey: kCIInputSaturationKey)
            filter?.setValue(1.1, forKey: kCIInputContrastKey)
        case "gothic":
            filter?.setValue(0.7, forKey: kCIInputSaturationKey)
            filter?.setValue(1.2, forKey: kCIInputContrastKey)
        default:
            filter?.setValue(1.0, forKey: kCIInputSaturationKey)
            filter?.setValue(1.0, forKey: kCIInputContrastKey)
        }

        guard let outputImage = filter?.outputImage else { return image }

        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }

        return UIImage(cgImage: cgImage)
    }
}
