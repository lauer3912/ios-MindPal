import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        let journalVC = JournalViewController()
        journalVC.tabBarItem = UITabBarItem(title: "Journal", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book.fill"))

        let insightsVC = InsightsViewController()
        insightsVC.tabBarItem = UITabBarItem(title: "Insights", image: UIImage(systemName: "chart.line.uptrend.xyaxis"), selectedImage: UIImage(systemName: "chart.line.uptrend.xyaxis"))

        let growthVC = GrowthViewController()
        growthVC.tabBarItem = UITabBarItem(title: "Growth", image: UIImage(systemName: "leaf"), selectedImage: UIImage(systemName: "leaf.fill"))

        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))

        viewControllers = [journalVC, insightsVC, growthVC, settingsVC].map { UINavigationController(rootViewController: $0) }
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Theme.Colors.adaptiveBgPrimary
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = Theme.Colors.accentPrimary
        tabBar.unselectedItemTintColor = Theme.Colors.adaptiveTextSecondary
    }
}