import UIKit
import SnapKit

class SettingsViewController: UIViewController {

    private let settingsService = SettingsService.shared

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = Theme.Typography.heading1()
        label.textColor = Theme.Colors.txtPrimary
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = Theme.Colors.bgPrimary
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tv.register(SwitchCell.self, forCellReuseIdentifier: "SwitchCell")
        return tv
    }()

    private enum Section: Int, CaseIterable {
        case appearance
        case workday
        case notifications
        case focusMode
        case feedback
        case data
        case about

        var title: String {
            switch self {
            case .appearance: return "Appearance"
            case .workday: return "Workday"
            case .notifications: return "Notifications"
            case .focusMode: return "Focus Mode"
            case .feedback: return "Feedback"
            case .data: return "Data"
            case .about: return "About"
            }
        }

        var rowCount: Int {
            switch self {
            case .appearance: return 3
            case .workday: return 3
            case .notifications: return 2
            case .focusMode: return 2
            case .feedback: return 2
            case .data: return 3
            case .about: return 3
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tableView.reloadData()
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.bgPrimary

        [headerLabel, tableView].forEach { view.addSubview($0) }

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate & DataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section(rawValue: section)?.rowCount ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch sectionType {
        case .appearance:
            return appearanceCell(for: indexPath)
        case .workday:
            return workdayCell(for: indexPath)
        case .notifications:
            return notificationsCell(for: indexPath)
        case .focusMode:
            return focusModeCell(for: indexPath)
        case .feedback:
            return feedbackCell(for: indexPath)
        case .data:
            return dataCell(for: indexPath)
        case .about:
            return aboutCell(for: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let sectionType = Section(rawValue: indexPath.section) else { return }

        switch sectionType {
        case .appearance:
            handleAppearanceSelection(indexPath)
        case .workday:
            handleWorkdaySelection(indexPath)
        case .notifications:
            handleNotificationsSelection(indexPath)
        case .focusMode:
            handleFocusModeSelection(indexPath)
        case .feedback:
            break
        case .data:
            handleDataSelection(indexPath)
        case .about:
            handleAboutSelection(indexPath)
        }
    }

    // MARK: - Cell Creation

    private func appearanceCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = Theme.Colors.bgSecondary
        cell.textLabel?.textColor = Theme.Colors.txtPrimary
        cell.tintColor = Theme.Colors.accentPrimary
        cell.accessoryType = .none

        let settings = settingsService.settings

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Dark Mode"
            cell.accessoryType = settings.theme == .dark ? .checkmark : .none
        case 1:
            cell.textLabel?.text = "Light Mode"
            cell.accessoryType = settings.theme == .light ? .checkmark : .none
        case 2:
            cell.textLabel?.text = "Follow System"
            cell.accessoryType = settings.theme == .system ? .checkmark : .none
        default:
            break
        }

        return cell
    }

    private func workdayCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = Theme.Colors.bgSecondary
        cell.textLabel?.textColor = Theme.Colors.txtPrimary
        cell.accessoryType = .disclosureIndicator

        let settings = settingsService.settings

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Start Hour"
            cell.detailTextLabel?.text = String(format: "%02d:00", settings.workdayStartHour)
        case 1:
            cell.textLabel?.text = "End Hour"
            cell.detailTextLabel?.text = String(format: "%02d:00", settings.workdayEndHour)
        case 2:
            cell.textLabel?.text = "Work Days"
            cell.detailTextLabel?.text = workDaysDisplay(settings.workDays)
        default:
            break
        }

        return cell
    }

    private func workDaysDisplay(_ days: [Int]) -> String {
        let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let selected = days.map { dayNames[$0 - 1] }.joined(separator: ", ")
        return selected.isEmpty ? "None" : selected
    }

    private func notificationsCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell

        switch indexPath.row {
        case 0:
            cell.configure(title: "Enable Notifications", isOn: true) { [weak self] isOn in
                // Handle notifications toggle
            }
        case 1:
            let settings = settingsService.settings
            cell.configure(title: "Morning Briefing", isOn: true) { [weak self] isOn in
                // Handle briefing toggle
            }
        default:
            break
        }

        return cell
    }

    private func focusModeCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell

        switch indexPath.row {
        case 0:
            let settings = settingsService.settings
            cell.configure(title: "Focus Mode", isOn: settings.focusModeEnabled) { [weak self] isOn in
                self?.settingsService.toggleFocusMode(isOn)
            }
        case 1:
            let settings = settingsService.settings
            cell.configure(title: "Do Not Disturb", isOn: settings.doNotDisturbEnabled) { [weak self] isOn in
                self?.settingsService.toggleDoNotDisturb(isOn)
            }
        default:
            break
        }

        return cell
    }

    private func feedbackCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        let settings = settingsService.settings

        switch indexPath.row {
        case 0:
            cell.configure(title: "Sound Effects", isOn: settings.soundEffectsEnabled) { [weak self] isOn in
                self?.settingsService.toggleSoundEffects(isOn)
            }
        case 1:
            cell.configure(title: "Haptic Feedback", isOn: settings.hapticFeedbackEnabled) { [weak self] isOn in
                self?.settingsService.toggleHapticFeedback(isOn)
            }
        default:
            break
        }

        return cell
    }

    private func dataCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = Theme.Colors.bgSecondary
        cell.textLabel?.textColor = Theme.Colors.txtPrimary
        cell.accessoryType = .disclosureIndicator

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "iCloud Sync"
            let syncCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            let settings = settingsService.settings
            syncCell.configure(title: "iCloud Sync", isOn: settings.iCloudSyncEnabled) { [weak self] isOn in
                self?.settingsService.toggleICloudSync(isOn)
            }
            return syncCell
        case 1:
            cell.textLabel?.text = "Export Data"
            cell.accessoryType = .disclosureIndicator
        case 2:
            cell.textLabel?.text = "Import Data"
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }

        return cell
    }

    private func aboutCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = Theme.Colors.bgSecondary
        cell.textLabel?.textColor = Theme.Colors.txtPrimary

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Privacy Policy"
            cell.accessoryType = .disclosureIndicator
        case 1:
            cell.textLabel?.text = "Terms of Service"
            cell.accessoryType = .disclosureIndicator
        case 2:
            cell.textLabel?.text = "Rate App"
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }

        return cell
    }

    // MARK: - Selection Handlers

    private func handleAppearanceSelection(_ indexPath: IndexPath) {
        let themes: [AppTheme] = [.dark, .light, .system]
        let theme = themes[indexPath.row]
        settingsService.updateTheme(theme)
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    }

    private func handleWorkdaySelection(_ indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            showHourPicker(title: "Workday Start", currentHour: settingsService.settings.workdayStartHour) { [weak self] hour in
                guard let self = self else { return }
                let current = self.settingsService.settings
                self.settingsService.updateWorkday(hour, current.workdayEndHour, current.workDays)
                self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            }
        case 1:
            showHourPicker(title: "Workday End", currentHour: settingsService.settings.workdayEndHour) { [weak self] hour in
                guard let self = self else { return }
                let current = self.settingsService.settings
                self.settingsService.updateWorkday(current.workdayStartHour, hour, current.workDays)
                self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            }
        case 2:
            showWorkDaysPicker()
        default:
            break
        }
    }

    private func handleNotificationsSelection(_ indexPath: IndexPath) {
        // Handle notification settings
    }

    private func handleFocusModeSelection(_ indexPath: IndexPath) {
        // Focus mode handled by switches
    }

    private func handleDataSelection(_ indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            exportData()
        case 2:
            importData()
        default:
            break
        }
    }

    private func handleAboutSelection(_ indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // Open privacy policy
            if let url = URL(string: "https://lauer3912.github.io/ios-DailyIQ/docs/PrivacyPolicy.html") {
                UIApplication.shared.open(url)
            }
        case 1:
            // Open terms of service
            if let url = URL(string: "https://lauer3912.github.io/ios-DailyIQ/docs/TermsOfService.html") {
                UIApplication.shared.open(url)
            }
        case 2:
            // Rate app - would use SKStoreReviewController in production
            break
        default:
            break
        }
    }

    // MARK: - Pickers

    private func showHourPicker(title: String, currentHour: Int, completion: @escaping (Int) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        for hour in 0..<24 {
            let action = UIAlertAction(title: String(format: "%02d:00", hour), style: .default) { _ in
                completion(hour)
            }
            if hour == currentHour {
                action.setValue(true, forKey: "checked")
            }
            alert.addAction(action)
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func showWorkDaysPicker() {
        let alert = UIAlertController(title: "Work Days", message: nil, preferredStyle: .actionSheet)

        let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let currentDays = settingsService.settings.workDays

        for (index, day) in days.enumerated() {
            let weekday = index + 1
            let action = UIAlertAction(title: day, style: .default) { [weak self] _ in
                guard let self = self else { return }
                var newDays = self.settingsService.settings.workDays
                if newDays.contains(weekday) {
                    newDays.removeAll { $0 == weekday }
                } else {
                    newDays.append(weekday)
                    newDays.sort()
                }
                let current = self.settingsService.settings
                self.settingsService.updateWorkday(current.workdayStartHour, current.workdayEndHour, newDays)
                self.tableView.reloadSections(IndexSet(integer: Section.workday.rawValue), with: .automatic)
            }
            if currentDays.contains(weekday) {
                action.setValue(true, forKey: "checked")
            }
            alert.addAction(action)
        }

        alert.addAction(UIAlertAction(title: "Done", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - Data Export/Import

    private func exportData() {
        let settings = settingsService.settings
        if let data = try? JSONEncoder().encode(settings) {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsPath.appendingPathComponent("dailyiq_settings.json")
            do {
                try data.write(to: fileURL)
                showAlert(title: "Export Successful", message: "Settings exported to Documents/dailyiq_settings.json")
            } catch {
                showAlert(title: "Export Failed", message: error.localizedDescription)
            }
        }
    }

    private func importData() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsPath.appendingPathComponent("dailyiq_settings.json")

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            showAlert(title: "Import Failed", message: "No backup file found")
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let importedSettings = try JSONDecoder().decode(UserSettings.self, from: data)
            settingsService.saveUserSettings(importedSettings)
            showAlert(title: "Import Successful", message: "Settings imported successfully")
            tableView.reloadData()
        } catch {
            showAlert(title: "Import Failed", message: error.localizedDescription)
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - SwitchCell

class SwitchCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let toggleSwitch = UISwitch()
    private var onToggle: ((Bool) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = Theme.Colors.bgSecondary
        selectionStyle = .none

        titleLabel.font = Theme.Typography.body()
        titleLabel.textColor = Theme.Colors.txtPrimary

        toggleSwitch.onTintColor = Theme.Colors.accentPrimary
        toggleSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)

        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Theme.Spacing.md)
            make.centerY.equalToSuperview()
        }

        toggleSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Theme.Spacing.md)
            make.centerY.equalToSuperview()
        }
    }

    func configure(title: String, isOn: Bool, onToggle: @escaping (Bool) -> Void) {
        titleLabel.text = title
        toggleSwitch.isOn = isOn
        self.onToggle = onToggle

        isAccessibilityElement = true
        accessibilityLabel = title
        accessibilityHint = "Double tap to \(isOn ? "disable" : "enable")"
        accessibilityTraits = .button
        accessibilityValue = isOn ? "On" : "Off"
    }

    @objc private func switchChanged() {
        onToggle?(toggleSwitch.isOn)
        accessibilityValue = toggleSwitch.isOn ? "On" : "Off"
    }
}