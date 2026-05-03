import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupViewControllers()
    }

    private func setupAppearance() {
        tabBar.backgroundColor = UIColor(hex: "#0F0F14")
        tabBar.barTintColor = UIColor(hex: "#0F0F14")
        tabBar.tintColor = UIColor(hex: "#9B8FE8")
        tabBar.unselectedItemTintColor = UIColor(hex: "#A1A1AA")
        tabBar.isTranslucent = false

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(hex: "#0F0F14")
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }

    private func setupViewControllers() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        let challengesVC = UINavigationController(rootViewController: ChallengesViewController())
        challengesVC.tabBarItem = UITabBarItem(
            title: "Challenges",
            image: UIImage(systemName: "brain"),
            selectedImage: UIImage(systemName: "brain.fill")
        )

        let mirrorVC = UINavigationController(rootViewController: MirrorViewController())
        mirrorVC.tabBarItem = UITabBarItem(
            title: "Mirror",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")
        )

        let dreamsVC = UINavigationController(rootViewController: DreamsViewController())
        dreamsVC.tabBarItem = UITabBarItem(
            title: "Dreams",
            image: UIImage(systemName: "moon.stars"),
            selectedImage: UIImage(systemName: "moon.stars.fill")
        )

        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        viewControllers = [homeVC, challengesVC, mirrorVC, dreamsVC, profileVC]
    }
}

// MARK: - Color Extension

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