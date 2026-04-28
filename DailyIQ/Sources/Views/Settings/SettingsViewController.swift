import UIKit
import SnapKit

class SettingsViewController: UIViewController {

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
        return tv
    }()

    private let sections: [(String, [String])] = [
        ("Profile", ["Name", "Timezone"]),
        ("Appearance", ["Dark Mode"]),
        ("AI Settings", ["Planning Aggressiveness", "Auto-Regenerate"]),
        ("Notifications", ["Reminders", "Quiet Hours"]),
        ("Data", ["Export Data", "iCloud Sync"]),
        ("Pro", ["Upgrade to Pro"]),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].1.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let settingName = sections[indexPath.section].1[indexPath.row]
        cell.textLabel?.text = settingName
        cell.textLabel?.textColor = Theme.Colors.txtPrimary
        cell.backgroundColor = Theme.Colors.bgSecondary
        cell.accessoryType = .disclosureIndicator
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = "\(settingName) setting"
        cell.accessibilityTraits = .button

        if indexPath.section == 5 && indexPath.row == 0 {
            cell.textLabel?.textColor = Theme.Colors.accentPrimary
            cell.accessoryType = .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
