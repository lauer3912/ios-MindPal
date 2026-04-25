import UIKit

enum Theme {

    // MARK: - Colors

    enum Colors {
        // Dark Theme (Default)
        static let backgroundPrimary = UIColor(hex: "#09090B")
        static let backgroundSecondary = UIColor(hex: "#141417")
        static let backgroundTertiary = UIColor(hex: "#1E1E22")
        static let accentPrimary = UIColor(hex: "#6366F1")
        static let accentSecondary = UIColor(hex: "#22D3EE")
        static let accentWarm = UIColor(hex: "#F59E0B")
        static let textPrimary = UIColor(hex: "#FAFAFA")
        static let textSecondary = UIColor(hex: "#A1A1AA")
        static let textTertiary = UIColor(hex: "#52525B")
        static let border = UIColor(hex: "#27272A")
        static let success = UIColor(hex: "#10B981")
        static let warning = UIColor(hex: "#F59E0B")
        static let destructive = UIColor(hex: "#EF4444")

        // Light Theme
        static let lightBackgroundPrimary = UIColor(hex: "#FFFFFF")
        static let lightBackgroundSecondary = UIColor(hex: "#F4F4F5")
        static let lightBackgroundTertiary = UIColor(hex: "#E4E4E7")
        static let lightTextPrimary = UIColor(hex: "#18181B")
        static let lightTextSecondary = UIColor(hex: "#71717A")

        static var isDarkMode: Bool {
            return UIScreen.main.traitCollection.userInterfaceStyle == .dark
        }

        static var bgPrimary: UIColor {
            isDarkMode ? backgroundPrimary : lightBackgroundPrimary
        }

        static var bgSecondary: UIColor {
            isDarkMode ? backgroundSecondary : lightBackgroundSecondary
        }

        static var bgTertiary: UIColor {
            isDarkMode ? backgroundTertiary : lightBackgroundTertiary
        }

        static var txtPrimary: UIColor {
            isDarkMode ? textPrimary : lightTextPrimary
        }

        static var txtSecondary: UIColor {
            isDarkMode ? textSecondary : lightTextSecondary
        }
    }

    // MARK: - Spacing

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    // MARK: - Corner Radius

    enum CornerRadius {
        static let card: CGFloat = 16
        static let button: CGFloat = 12
        static let small: CGFloat = 8
    }

    // MARK: - Typography

    enum Typography {
        static func heading1() -> UIFont {
            .systemFont(ofSize: 28, weight: .bold)
        }

        static func heading2() -> UIFont {
            .systemFont(ofSize: 22, weight: .semibold)
        }

        static func body() -> UIFont {
            .systemFont(ofSize: 16, weight: .regular)
        }

        static func caption() -> UIFont {
            .systemFont(ofSize: 13, weight: .regular)
        }

        static func mono() -> UIFont {
            .monospacedSystemFont(ofSize: 16, weight: .medium)
        }
    }
}

// MARK: - UIColor Extension

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}
