import UIKit

extension UIColor {

    // MARK: - Primary Colors

    static let primary = UIColor(hex: "#6C3CE9")
    static let secondary = UIColor(hex: "#00D4FF")
    static let accent = UIColor(hex: "#FF00FF")

    // MARK: - Background Colors

    static let backgroundDark = UIColor(hex: "#0D0D1A")
    static let backgroundLight = UIColor(hex: "#F5F5FA")

    // MARK: - Surface Colors

    static let surfaceDark = UIColor(hex: "#1A1A2E")
    static let surfaceLight = UIColor(hex: "#FFFFFF")

    // MARK: - Text Colors

    static let textPrimaryDark = UIColor(hex: "#FFFFFF")
    static let textPrimaryLight = UIColor(hex: "#1A1A2E")
    static let textSecondary = UIColor(hex: "#8B8B9E")

    // MARK: - Semantic Colors

    static let success = UIColor(hex: "#00E676")
    static let error = UIColor(hex: "#FF5252")

    // MARK: - Convenience Init

    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    // MARK: - Gradient Colors

    static var primaryGradient: [CGColor] {
        return [primary.cgColor, secondary.cgColor]
    }

    static var accentGradient: [CGColor] {
        return [primary.cgColor, accent.cgColor]
    }
}
