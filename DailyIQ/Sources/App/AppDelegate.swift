import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize services
        initializeServices()

        // Configure appearance
        configureAppearance()

        // Set up notifications
        setupNotifications()

        // Apply saved theme
        SettingsService.shared.applyTheme()

        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - Service Initialization

    private func initializeServices() {
        // Initialize singleton services to set up databases
        _ = TaskService.shared
        _ = GoalService.shared
        _ = SettingsService.shared
        _ = AISchedulingService.shared
        _ = InsightsService.shared
        _ = NotificationService.shared
    }

    // MARK: - Appearance

    private func configureAppearance() {
        // Navigation Bar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = Theme.Colors.backgroundPrimary
        navBarAppearance.titleTextAttributes = [.foregroundColor: Theme.Colors.textPrimary]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: Theme.Colors.textPrimary]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().tintColor = Theme.Colors.accentPrimary

        // Tab Bar
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = Theme.Colors.backgroundPrimary
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = Theme.Colors.accentPrimary
    }

    // MARK: - Notifications

    private func setupNotifications() {
        // Set up notification categories
        NotificationService.shared.setupNotificationCategories()

        // Request authorization if enabled
        if SettingsService.shared.notificationsEnabled {
            NotificationService.shared.requestAuthorization { granted in
                if granted {
                    self.scheduleDefaultNotifications()
                }
            }
        }
    }

    private func scheduleDefaultNotifications() {
        // Schedule morning briefing
        NotificationService.shared.scheduleMorningBriefing(
            hour: SettingsService.shared.morningBriefingHour,
            minute: SettingsService.shared.morningBriefingMinute
        )

        // Schedule evening review
        NotificationService.shared.scheduleEveningReview(
            hour: SettingsService.shared.eveningReviewHour,
            minute: SettingsService.shared.eveningReviewMinute
        )
    }

    // MARK: - Scene Configuration

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        // Handle discarded scenes if needed
    }
}
