import UIKit

enum Theme {
    enum Colors {
        // Dark Theme
        static let bgPrimary = UIColor(hex: "#0F0F14")
        static let bgSecondary = UIColor(hex: "#1A1A24")
        static let bgTertiary = UIColor(hex: "#252532")
        static let accentPrimary = UIColor(hex: "#9B8FE8")
        static let accentSecondary = UIColor(hex: "#6EE7B7")
        static let accentWarm = UIColor(hex: "#FCD34D")
        static let textPrimary = UIColor(hex: "#F5F5F7")
        static let textSecondary = UIColor(hex: "#A1A1AA")
        static let textTertiary = UIColor(hex: "#6B6B7A")
        static let border = UIColor(hex: "#2D2D3D")
        static let cardBg = UIColor(hex: "#1A1A24")

        // Light Theme
        static let lightBgPrimary = UIColor(hex: "#FEFEFE")
        static let lightBgSecondary = UIColor(hex: "#F5F5F7")
        static let lightBgTertiary = UIColor(hex: "#EDEDEF")
        static let lightTextPrimary = UIColor(hex: "#1A1A24")
        static let lightTextSecondary = UIColor(hex: "#6B6B7A")
        static let lightAccentPrimary = UIColor(hex: "#7C6FD9")
        static let lightCardBg = UIColor(hex: "#FFFFFF")

        // Mood Colors
        static let moodHappy = UIColor(hex: "#6EE7B7")
        static let moodNeutral = UIColor(hex: "#9B8FE8")
        static let moodSad = UIColor(hex: "#60A5FA")
        static let moodAnxious = UIColor(hex: "#FBBF24")
        static let moodAngry = UIColor(hex: "#F87171")
        static let moodCalm = UIColor(hex: "#A78BFA")

        static var adaptiveBgPrimary: UIColor {
            UIScreen.main.traitCollection.userInterfaceStyle == .dark ? bgPrimary : lightBgPrimary
        }
        static var adaptiveBgSecondary: UIColor {
            UIScreen.main.traitCollection.userInterfaceStyle == .dark ? bgSecondary : lightBgSecondary
        }
        static var adaptiveCardBg: UIColor {
            UIScreen.main.traitCollection.userInterfaceStyle == .dark ? cardBg : lightCardBg
        }
        static var adaptiveTextPrimary: UIColor {
            UIScreen.main.traitCollection.userInterfaceStyle == .dark ? textPrimary : lightTextPrimary
        }
        static var adaptiveTextSecondary: UIColor {
            UIScreen.main.traitCollection.userInterfaceStyle == .dark ? textSecondary : lightTextSecondary
        }
        static var adaptiveAccent: UIColor {
            UIScreen.main.traitCollection.userInterfaceStyle == .dark ? accentPrimary : lightAccentPrimary
        }
    }

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    enum CornerRadius {
        static let card: CGFloat = 16
        static let button: CGFloat = 12
        static let small: CGFloat = 8
        static let large: CGFloat = 24
    }

    enum Typography {
        static func heading1() -> UIFont { .systemFont(ofSize: 28, weight: .semibold) }
        static func heading2() -> UIFont { .systemFont(ofSize: 22, weight: .medium) }
        static func heading3() -> UIFont { .systemFont(ofSize: 18, weight: .semibold) }
        static func body() -> UIFont { .systemFont(ofSize: 16, weight: .regular) }
        static func bodyBold() -> UIFont { .systemFont(ofSize: 16, weight: .semibold) }
        static func caption() -> UIFont { .systemFont(ofSize: 13, weight: .regular) }
        static func quote() -> UIFont { .italicSystemFont(ofSize: 18) }
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (r, g, b) = (0, 0, 0)
        }
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }
}