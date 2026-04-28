import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        let todayVC = TodayViewController()
        todayVC.tabBarItem = UITabBarItem(
            title: "Today",
            image: UIImage(systemName: "sun.max"),
            selectedImage: UIImage(systemName: "sun.max.fill")
        )
        todayVC.tabBarItem.accessibilityLabel = "Today tab"
        todayVC.tabBarItem.accessibilityHint = "Navigate to today's schedule"

        let calendarVC = CalendarViewController()
        calendarVC.tabBarItem = UITabBarItem(
            title: "Calendar",
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar.circle.fill")
        )
        calendarVC.tabBarItem.accessibilityLabel = "Calendar tab"
        calendarVC.tabBarItem.accessibilityHint = "Navigate to calendar view"

        let goalsVC = GoalsViewController()
        goalsVC.tabBarItem = UITabBarItem(
            title: "Goals",
            image: UIImage(systemName: "target"),
            selectedImage: UIImage(systemName: "target")
        )
        goalsVC.tabBarItem.accessibilityLabel = "Goals tab"
        goalsVC.tabBarItem.accessibilityHint = "Navigate to goals tracking"

        let insightsVC = InsightsViewController()
        insightsVC.tabBarItem = UITabBarItem(
            title: "Insights",
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )
        insightsVC.tabBarItem.accessibilityLabel = "Insights tab"
        insightsVC.tabBarItem.accessibilityHint = "Navigate to productivity insights"

        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        settingsVC.tabBarItem.accessibilityLabel = "Settings tab"
        settingsVC.tabBarItem.accessibilityHint = "Navigate to app settings"

        let vcs = [todayVC, calendarVC, goalsVC, insightsVC, settingsVC]
        viewControllers = vcs.map { UINavigationController(rootViewController: $0) }
    }
}
