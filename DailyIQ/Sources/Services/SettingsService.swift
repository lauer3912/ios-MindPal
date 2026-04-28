import Foundation
import UIKit

final class SettingsService {
    static let shared = SettingsService()

    private let dataService = DataService.shared
    private(set) var settings: UserSettings

    private init() {
        settings = dataService.getUserSettings()
    }

    func updateTheme(_ theme: AppTheme) {
        settings.theme = theme
        applyTheme()
        save()
    }

    func updateLanguage(_ language: AppLanguage) {
        settings.language = language
        save()
    }

    func updateWorkday(_ startHour: Int, _ endHour: Int, _ workDays: [Int]) {
        settings.workdayStartHour = startHour
        settings.workdayEndHour = endHour
        settings.workDays = workDays
        save()
    }

    func updateDefaultReminder(_ reminder: EventReminder) {
        settings.defaultReminder = reminder
        save()
    }

    func toggleFocusMode(_ enabled: Bool) {
        settings.focusModeEnabled = enabled
        save()
    }

    func toggleDoNotDisturb(_ enabled: Bool) {
        settings.doNotDisturbEnabled = enabled
        save()
    }

    func toggleHapticFeedback(_ enabled: Bool) {
        settings.hapticFeedbackEnabled = enabled
        save()
    }

    func toggleSoundEffects(_ enabled: Bool) {
        settings.soundEffectsEnabled = enabled
        save()
    }

    func toggleBiometric(_ enabled: Bool) {
        settings.biometricEnabled = enabled
        save()
    }

    func toggleICloudSync(_ enabled: Bool) {
        settings.iCloudSyncEnabled = enabled
        save()
    }

    func updateWidgetSize(_ size: WidgetSize) {
        settings.widgetSize = size
        save()
    }

    func updateAccentColor(_ color: AccentColorOption) {
        settings.accentColor = color
        save()
    }

    private func save() {
        dataService.saveUserSettings(settings)
    }

    func applyTheme() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        switch settings.theme {
        case .light:
            window.overrideUserInterfaceStyle = .light
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        case .system:
            window.overrideUserInterfaceStyle = .unspecified
        }
    }

    func saveUserSettings(_ newSettings: UserSettings) {
        settings = newSettings
        dataService.saveUserSettings(settings)
        applyTheme()
    }

    var isWorkday: Bool {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return settings.workDays.contains(weekday)
    }

    var workdayStart: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = settings.workdayStartHour
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }

    var workdayEnd: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = settings.workdayEndHour
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
}