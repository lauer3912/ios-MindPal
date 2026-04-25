import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private let sections: [(title: String, items: [(icon: String, title: String, detail: String?)])] = [
        ("Appearance", [
            ("moon.fill", "Dark Mode", "On"),
            ("textformat.size", "Font Size", "Medium"),
        ]),
        ("Notifications", [
            ("bell.fill", "Daily Reminder", "9:00 PM"),
            ("bell.badge", "Weekly Report", "Sunday"),
        ]),
        ("Privacy", [
            ("faceid", "Face ID Lock", "Off"),
            ("lock.fill", "Private Mode", nil),
        ]),
        ("Data", [
            ("icloud.fill", "iCloud Sync", "Off"),
            ("square.and.arrow.up", "Export Data", nil),
        ]),
        ("About", [
            ("info.circle", "Version", "1.0.0"),
            ("star.fill", "Rate MindPal", nil),
        ]),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.adaptiveBgPrimary

        let headerLabel = UILabel()
        headerLabel.text = "Settings"
        headerLabel.font = Theme.Typography.heading1()
        headerLabel.textColor = Theme.Colors.adaptiveTextPrimary
        view.addSubview(headerLabel)

        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = sections[indexPath.section].items[indexPath.row]

        var config = cell.defaultContentConfiguration()
        config.text = item.title
        config.secondaryText = item.detail
        config.image = UIImage(systemName: item.icon)
        config.imageProperties.tintColor = Theme.Colors.accentPrimary

        cell.contentConfiguration = config
        cell.backgroundColor = Theme.Colors.adaptiveCardBg
        cell.accessoryType = item.detail != nil ? .none : .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}