import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupTabs()
    }

    private func setupAppearance() {
        // Tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Theme.Colors.bgSecondary

        // Normal state
        appearance.stackedLayoutAppearance.normal.iconColor = Theme.Colors.txtSecondary
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: Theme.Colors.txtSecondary,
            .font: Theme.Typography.tabBar()
        ]

        // Selected state
        appearance.stackedLayoutAppearance.selected.iconColor = Theme.Colors.accentPrimary
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: Theme.Colors.accentPrimary,
            .font: Theme.Typography.tabBar()
        ]

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        tabBar.tintColor = Theme.Colors.accentPrimary
    }

    private func setupTabs() {
        // Today Tab
        let todayVC = TodayViewController()
        todayVC.tabBarItem = UITabBarItem(
            title: "Today",
            image: UIImage(systemName: "sun.max"),
            selectedImage: UIImage(systemName: "sun.max.fill")
        )
        todayVC.tabBarItem.accessibilityLabel = "Today tab"
        todayVC.tabBarItem.accessibilityHint = "Navigate to today's schedule"

        // Calendar Tab
        let calendarVC = CalendarViewController()
        calendarVC.tabBarItem = UITabBarItem(
            title: "Calendar",
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar.circle.fill")
        )
        calendarVC.tabBarItem.accessibilityLabel = "Calendar tab"
        calendarVC.tabBarItem.accessibilityHint = "Navigate to calendar view"

        // AI Chat Tab
        let aiChatVC = AIChatViewController()
        aiChatVC.tabBarItem = UITabBarItem(
            title: "AI",
            image: UIImage(systemName: "brain"),
            selectedImage: UIImage(systemName: "brain.head.profile")
        )
        aiChatVC.tabBarItem.accessibilityLabel = "AI Assistant tab"
        aiChatVC.tabBarItem.accessibilityHint = "Chat with AI scheduling assistant"

        // Goals Tab
        let goalsVC = GoalsViewController()
        goalsVC.tabBarItem = UITabBarItem(
            title: "Goals",
            image: UIImage(systemName: "target"),
            selectedImage: UIImage(systemName: "target")
        )
        goalsVC.tabBarItem.accessibilityLabel = "Goals tab"
        goalsVC.tabBarItem.accessibilityHint = "Navigate to goals tracking"

        // Insights Tab
        let insightsVC = InsightsViewController()
        insightsVC.tabBarItem = UITabBarItem(
            title: "Insights",
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )
        insightsVC.tabBarItem.accessibilityLabel = "Insights tab"
        insightsVC.tabBarItem.accessibilityHint = "Navigate to productivity insights"

        // Settings Tab
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        settingsVC.tabBarItem.accessibilityLabel = "Settings tab"
        settingsVC.tabBarItem.accessibilityHint = "Navigate to app settings"

        // Create navigation controllers
        let todayNav = UINavigationController(rootViewController: todayVC)
        let calendarNav = UINavigationController(rootViewController: calendarVC)
        let aiChatNav = UINavigationController(rootViewController: aiChatVC)
        let goalsNav = UINavigationController(rootViewController: goalsVC)
        let insightsNav = UINavigationController(rootViewController: insightsVC)
        let settingsNav = UINavigationController(rootViewController: settingsVC)

        // Hide navigation bars for all tabs
        [todayNav, calendarNav, aiChatNav, goalsNav, insightsNav, settingsNav].forEach {
            $0.navigationBar.isHidden = true
        }

        viewControllers = [todayNav, calendarNav, aiChatNav, goalsNav, insightsNav, settingsNav]
    }
}