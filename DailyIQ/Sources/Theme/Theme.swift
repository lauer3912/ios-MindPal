import UIKit

enum Theme {

    // MARK: - Colors (Approved UI Colors)

    enum Colors {
        // MARK: Dark Theme (Default)
        static let backgroundPrimary = UIColor(hex: "#0F0F14")
        static let backgroundSecondary = UIColor(hex: "#18181F")
        static let backgroundTertiary = UIColor(hex: "#232329")
        static let backgroundCard = UIColor(hex: "#1C1C24")

        // Approved Primary Colors
        static let accentPrimary = UIColor(hex: "#9B8FE8")     // Violet
        static let accentSecondary = UIColor(hex: "#6EE7B7")   // Mint Green
        static let accentWarm = UIColor(hex: "#FCD34D")       // Amber

        // Dark mode text
        static let textPrimary = UIColor(hex: "#FFFFFF")
        static let textSecondary = UIColor(hex: "#A1A1AA")
        static let textTertiary = UIColor(hex: "#52525B")

        // Dark mode UI
        static let border = UIColor(hex: "#27272A")
        static let separator = UIColor(hex: "#27272A")

        // Status Colors
        static let success = UIColor(hex: "#6EE7B7")
        static let warning = UIColor(hex: "#FCD34D")
        static let destructive = UIColor(hex: "#EF4444")
        static let info = UIColor(hex: "#9B8FE8")

        // MARK: Light Theme
        static let lightBackgroundPrimary = UIColor(hex: "#FFFFFF")
        static let lightBackgroundSecondary = UIColor(hex: "#F5F5F7")
        static let lightBackgroundTertiary = UIColor(hex: "#E8E8EC")
        static let lightBackgroundCard = UIColor(hex: "#FFFFFF")

        // Light mode text
        static let lightTextPrimary = UIColor(hex: "#18181B")
        static let lightTextSecondary = UIColor(hex: "#52525B")
        static let lightTextTertiary = UIColor(hex: "#A1A1AA")

        // Light mode UI
        static let lightBorder = UIColor(hex: "#E4E4E7")
        static let lightSeparator = UIColor(hex: "#E4E4E7")

        // MARK: Dynamic Colors (auto dark/light)
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

        static var bgCard: UIColor {
            isDarkMode ? backgroundCard : lightBackgroundCard
        }

        static var txtPrimary: UIColor {
            isDarkMode ? textPrimary : lightTextPrimary
        }

        static var txtSecondary: UIColor {
            isDarkMode ? textSecondary : lightTextSecondary
        }

        static var txtTertiary: UIColor {
            isDarkMode ? textTertiary : lightTextTertiary
        }

        static var borderColor: UIColor {
            isDarkMode ? border : lightBorder
        }

        static var separatorColor: UIColor {
            isDarkMode ? separator : lightSeparator
        }

        // Accent colors remain same in both modes
        static let primary = accentPrimary
        static let secondary = accentSecondary
        static let warm = accentWarm
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
        static let large: CGFloat = 24
    }

    // MARK: - Shadows

    enum Shadow {
        static func card(_ view: UIView) {
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 4)
            view.layer.shadowRadius = 12
            view.layer.shadowOpacity = 0.3
        }

        static func button(_ view: UIView) {
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = 8
            view.layer.shadowOpacity = 0.2
        }
    }

    // MARK: - Typography

    enum Typography {
        static func heading1() -> UIFont {
            .systemFont(ofSize: 28, weight: .bold)
        }

        static func heading2() -> UIFont {
            .systemFont(ofSize: 22, weight: .semibold)
        }

        static func heading3() -> UIFont {
            .systemFont(ofSize: 18, weight: .semibold)
        }

        static func body() -> UIFont {
            .systemFont(ofSize: 16, weight: .regular)
        }

        static func bodyBold() -> UIFont {
            .systemFont(ofSize: 16, weight: .semibold)
        }

        static func caption() -> UIFont {
            .systemFont(ofSize: 13, weight: .regular)
        }

        static func captionBold() -> UIFont {
            .systemFont(ofSize: 13, weight: .semibold)
        }

        static func mono() -> UIFont {
            .monospacedSystemFont(ofSize: 16, weight: .medium)
        }

        static func tabBar() -> UIFont {
            .systemFont(ofSize: 10, weight: .medium)
        }
    }

    // MARK: - Animation

    enum Animation {
        static let fast: TimeInterval = 0.2
        static let normal: TimeInterval = 0.3
        static let slow: TimeInterval = 0.5

        static func spring() -> UIView.AnimationParameters {
            .init(damping: 0.8, velocity: 0.5)
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

// MARK: - UIView Animation Parameters

struct AnimationParameters {
    let damping: CGFloat
    let velocity: CGFloat

    static let `default` = AnimationParameters(damping: 1.0, velocity: 0.0)
    static let spring = AnimationParameters(damping: 0.8, velocity: 0.5)
}

extension UIView.AnimationParameters {
    static var spring: UIView.AnimationParameters {
        AnimationParameters(damping: 0.8, velocity: 0.5)
    }
}