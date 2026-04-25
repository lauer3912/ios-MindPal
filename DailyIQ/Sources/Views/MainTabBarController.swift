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

        let calendarVC = CalendarViewController()
        calendarVC.tabBarItem = UITabBarItem(
            title: "Calendar",
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar.circle.fill")
        )

        let goalsVC = GoalsViewController()
        goalsVC.tabBarItem = UITabBarItem(
            title: "Goals",
            image: UIImage(systemName: "target"),
            selectedImage: UIImage(systemName: "target")
        )

        let insightsVC = InsightsViewController()
        insightsVC.tabBarItem = UITabBarItem(
            title: "Insights",
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )

        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )

        let vcs = [todayVC, calendarVC, goalsVC, insightsVC, settingsVC]
        viewControllers = vcs.map { UINavigationController(rootViewController: $0) }
    }
}
