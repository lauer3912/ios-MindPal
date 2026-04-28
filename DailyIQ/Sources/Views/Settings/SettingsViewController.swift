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
        case notifications
        case timer
        case feedback
        case aiSettings
        case data

        var title: String {
            switch self {
            case .appearance: return "Appearance"
            case .notifications: return "Notifications"
            case .timer: return "Timer"
            case .feedback: return "Feedback"
            case .aiSettings: return "AI Settings"
            case .data: return "Data"
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
        guard let sectionType = Section(rawValue: section) else { return 0 }
        switch sectionType {
        case .appearance: return 3  // Dark Mode, Follow System, Light Mode
        case .notifications: return 2  // Enable Notifications, Morning Briefing
        case .timer: return 2  // Focus Duration, Break Duration
        case .feedback: return 2  // Sound, Haptic
        case .aiSettings: return 2  // Planning Aggressiveness, Auto-Regenerate
        case .data: return 2  // Export Data, Import Data
        }
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
        case .notifications:
            return notificationsCell(for: indexPath)
        case .timer:
            return timerCell(for: indexPath)
        case .feedback:
            return feedbackCell(for: indexPath)
        case .aiSettings:
            return aiSettingsCell(for: indexPath)
        case .data:
            return dataCell(for: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let sectionType = Section(rawValue: indexPath.section) else { return }

        switch sectionType {
        case .appearance:
            handleAppearanceSelection(indexPath)
        case .notifications:
            handleNotificationsSelection(indexPath)
        case .timer:
            handleTimerSelection(indexPath)
        case .feedback:
            break // Switch cells handled elsewhere
        case .aiSettings:
            handleAISettingsSelection(indexPath)
        case .data:
            handleDataSelection(indexPath)
        }
    }

    // MARK: - Cell Creation

    private func appearanceCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = Theme.Colors.bgSecondary
        cell.textLabel?.textColor = Theme.Colors.txtPrimary
        cell.accessoryType = .none

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Dark Mode"
            cell.accessoryType = settingsService.themeMode == .dark ? .checkmark : .none
            cell.tintColor = Theme.Colors.accentPrimary
        case 1:
            cell.textLabel?.text = "Light Mode"
            cell.accessoryType = settingsService.themeMode == .light ? .checkmark : .none
            cell.tintColor = Theme.Colors.accentPrimary
        case 2:
            cell.textLabel?.text = "Follow System"
            cell.accessoryType = settingsService.themeMode == .system ? .checkmark : .none
            cell.tintColor = Theme.Colors.accentPrimary
        default:
            break
        }

        cell.isAccessibilityElement = true
        cell.accessibilityLabel = cell.textLabel?.text
        cell.accessibilityHint = "Double tap to select"
        cell.accessibilityTraits = .button

        return cell
    }

    private func notificationsCell(for indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.configure(title: "Enable Notifications", isOn: settingsService.notificationsEnabled) { isOn in
                self.settingsService.notificationsEnabled = isOn
                if isOn {
                    NotificationService.shared.requestAuthorization { granted in
                        if !granted {
                            self.showAlert(title: "Notifications Disabled", message: "Please enable notifications in Settings")
                        }
                    }
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = Theme.Colors.bgSecondary
            cell.textLabel?.textColor = Theme.Colors.txtPrimary
            cell.textLabel?.text = "Morning Briefing"
            cell.detailTextLabel?.text = "\(settingsService.morningBriefingHour):\(String(format: "%02d", settingsService.morningBriefingMinute))"
            cell.accessoryType = .disclosureIndicator
            cell.isAccessibilityElement = true
            cell.accessibilityLabel = "Morning Briefing at \(cell.detailTextLabel?.text ?? "")"
            return cell
        default:
            return UITableViewCell()
        }
    }

    private func timerCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = Theme.Colors.bgSecondary
        cell.textLabel?.textColor = Theme.Colors.txtPrimary
        cell.accessoryType = .disclosureIndicator

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Focus Duration"
            cell.detailTextLabel?.text = "\(settingsService.defaultFocusDuration) min"
        case 1:
            cell.textLabel?.text = "Break Duration"
            cell.detailTextLabel?.text = "\(settingsService.defaultBreakDuration) min"
        default:
            break
        }

        cell.isAccessibilityElement = true
        cell.accessibilityLabel = "\(cell.textLabel?.text ?? ""): \(cell.detailTextLabel?.text ?? "")"

        return cell
    }

    private func feedbackCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell

        switch indexPath.row {
        case 0:
            cell.configure(title: "Sound Effects", isOn: settingsService.soundEnabled) { isOn in
                self.settingsService.soundEnabled = isOn
            }
        case 1:
            cell.configure(title: "Haptic Feedback", isOn: settingsService.hapticEnabled) { isOn in
                self.settingsService.hapticEnabled = isOn
                if isOn {
                    HapticManager.shared.selection()
                }
            }
        default:
            break
        }

        return cell
    }

    private func aiSettingsCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = Theme.Colors.bgSecondary
        cell.textLabel?.textColor = Theme.Colors.txtPrimary
        cell.accessoryType = .disclosureIndicator

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Planning Aggressiveness"
            cell.detailTextLabel?.text = settingsService.planningAggressiveness.displayName
        case 1:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell2.configure(title: "Auto-Regenerate Schedule", isOn: settingsService.autoRegenerate) { isOn in
                self.settingsService.autoRegenerate = isOn
            }
            return cell2
        default:
            break
        }

        cell.isAccessibilityElement = true
        cell.accessibilityLabel = "\(cell.textLabel?.text ?? ""): \(cell.detailTextLabel?.text ?? "")"

        return cell
    }

    private func dataCell(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = Theme.Colors.bgSecondary
        cell.textLabel?.textColor = Theme.Colors.txtPrimary

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Export Data"
            cell.accessoryType = .disclosureIndicator
        case 1:
            cell.textLabel?.text = "Import Data"
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }

        cell.isAccessibilityElement = true
        cell.accessibilityLabel = cell.textLabel?.text
        cell.accessibilityHint = "Double tap to \(indexPath.row == 0 ? "export" : "import")"
        cell.accessibilityTraits = .button

        return cell
    }

    // MARK: - Selection Handlers

    private func handleAppearanceSelection(_ indexPath: IndexPath) {
        let mode: SettingsService.ThemeMode
        switch indexPath.row {
        case 0: mode = .dark
        case 1: mode = .light
        case 2: mode = .system
        default: return
        }

        settingsService.themeMode = mode
        HapticManager.shared.selection()
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    }

    private func handleNotificationsSelection(_ indexPath: IndexPath) {
        if indexPath.row == 1 {
            // Morning briefing time picker
            showTimePicker(title: "Morning Briefing Time", currentHour: settingsService.morningBriefingHour, currentMinute: settingsService.morningBriefingMinute) { hour, minute in
                self.settingsService.morningBriefingHour = hour
                self.settingsService.morningBriefingMinute = minute
                NotificationService.shared.scheduleMorningBriefing(hour: hour, minute: minute)
                self.tableView.reloadData()
            }
        }
    }

    private func handleTimerSelection(_ indexPath: IndexPath) {
        let title: String
        let currentValue: Int
        switch indexPath.row {
        case 0:
            title = "Focus Duration"
            currentValue = settingsService.defaultFocusDuration
        case 1:
            title = "Break Duration"
            currentValue = settingsService.defaultBreakDuration
        default: return
        }

        showDurationPicker(title: title, currentValue: currentValue) { newValue in
            switch indexPath.row {
            case 0: self.settingsService.defaultFocusDuration = newValue
            case 1: self.settingsService.defaultBreakDuration = newValue
            default: break
            }
            self.tableView.reloadData()
        }
    }

    private func handleAISettingsSelection(_ indexPath: IndexPath) {
        if indexPath.row == 0 {
            // Planning aggressiveness picker
            let alert = UIAlertController(title: "Planning Aggressiveness", message: "How densely should AI schedule your day?", preferredStyle: .actionSheet)

            for aggressiveness in [SettingsService.PlanningAggressiveness.relaxed, .moderate, .aggressive] {
                let action = UIAlertAction(title: aggressiveness.displayName, style: .default) { _ in
                    self.settingsService.planningAggressiveness = aggressiveness
                    self.tableView.reloadData()
                }
                if settingsService.planningAggressiveness == aggressiveness {
                    action.setValue(true, forKey: "checked")
                }
                alert.addAction(action)
            }

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        }
    }

    private func handleDataSelection(_ indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            exportData()
        case 1:
            importData()
        default:
            break
        }
    }

    // MARK: - Pickers

    private func showTimePicker(title: String, currentHour: Int, currentMinute: Int, completion: @escaping (Int, Int) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.preferredDatePickerStyle = .wheels
        picker.countDownDuration = TimeInterval(currentHour * 3600 + currentMinute * 60)

        alert.view.addSubview(picker)
        picker.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(150)
        }

        alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            let components = Calendar.current.dateComponents([.hour, .minute], from: picker.date)
            completion(components.hour ?? 8, components.minute ?? 0)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        alert.view.addConstraint(height)

        present(alert, animated: true)
    }

    private func showDurationPicker(title: String, currentValue: Int, completion: @escaping (Int) -> Void) {
        let alert = UIAlertController(title: title, message: "Select duration in minutes", preferredStyle: .actionSheet)

        for duration in [15, 25, 30, 45, 60, 90, 120] {
            let action = UIAlertAction(title: "\(duration) min", style: .default) { _ in
                completion(duration)
            }
            if currentValue == duration {
                action.setValue(true, forKey: "checked")
            }
            alert.addAction(action)
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - Data Export/Import

    private func exportData() {
        guard let data = settingsService.exportData() else {
            showAlert(title: "Export Failed", message: "Could not export data")
            return
        }

        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsPath.appendingPathComponent("dailyiq_backup.json")

        do {
            try data.write(to: fileURL)
            showAlert(title: "Export Successful", message: "Data exported to Documents/dailyiq_backup.json")
        } catch {
            showAlert(title: "Export Failed", message: error.localizedDescription)
        }
    }

    private func importData() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsPath.appendingPathComponent("dailyiq_backup.json")

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            showAlert(title: "Import Failed", message: "No backup file found. Export data first.")
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            if settingsService.importData(data) {
                showAlert(title: "Import Successful", message: "Data imported successfully")
            } else {
                showAlert(title: "Import Failed", message: "Could not parse backup file")
            }
        } catch {
            showAlert(title: "Import Failed", message: error.localizedDescription)
        }
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
        HapticManager.shared.selection()
        accessibilityValue = toggleSwitch.isOn ? "On" : "Off"
    }
}
