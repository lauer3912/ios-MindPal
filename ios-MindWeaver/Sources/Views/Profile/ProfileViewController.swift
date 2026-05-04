import UIKit

class ProfileViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
    private let levelLabel = UILabel()
    private let statsCard = UIView()
    private let menuCard = UIView()
    private let signOutButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#0F0F14")
        title = "Profile"

        avatarView.backgroundColor = UIColor(hex: "#1C1C1E")
        avatarView.layer.cornerRadius = 50
        avatarView.layer.borderWidth = 3
        avatarView.layer.borderColor = UIColor(hex: "#9B8FE8").cgColor
        avatarView.translatesAutoresizingMaskIntoConstraints = false

        avatarLabel.text = "🧠"
        avatarLabel.font = .systemFont(ofSize: 48)
        avatarLabel.textAlignment = .center
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.text = "MindSeeker"
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        levelLabel.text = "Level 12 • 2,450 Points"
        levelLabel.font = .systemFont(ofSize: 15, weight: .regular)
        levelLabel.textColor = UIColor(hex: "#9B8FE8")
        levelLabel.translatesAutoresizingMaskIntoConstraints = false

        statsCard.backgroundColor = UIColor(hex: "#1C1C1E")
        statsCard.layer.cornerRadius = 16
        statsCard.translatesAutoresizingMaskIntoConstraints = false
        setupStatsCard()

        menuCard.backgroundColor = UIColor(hex: "#1C1C1E")
        menuCard.layer.cornerRadius = 16
        menuCard.translatesAutoresizingMaskIntoConstraints = false
        setupMenuCard()

        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(UIColor(hex: "#EF4444"), for: .normal)
        signOutButton.backgroundColor = UIColor(hex: "#1C1C1E")
        signOutButton.layer.cornerRadius = 12
        signOutButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
    }

    private func setupStatsCard() {
        let stats = [
            ("Predictions", "156"),
            ("Correct", "89"),
            ("Streak", "5 days")
        ]

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        for (title, value) in stats {
            let statView = createStatView(title: title, value: value)
            stackView.addArrangedSubview(statView)
        }

        statsCard.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: statsCard.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: statsCard.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: statsCard.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: statsCard.bottomAnchor, constant: -16)
        ])
    }

    private func createStatView(title: String, value: String) -> UIView {
        let view = UIView()

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 24, weight: .bold)
        valueLabel.textColor = UIColor(hex: "#9B8FE8")
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = UIColor(hex: "#A1A1AA")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(valueLabel)
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: view.topAnchor),
            valueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }

    private func setupMenuCard() {
        let menuItems = [
            ("person.circle", "Account"),
            ("bell", "Notifications"),
            ("lock", "Privacy"),
            ("paintbrush", "Appearance"),
            ("questionmark.circle", "Help"),
            ("info.circle", "About")
        ]

        var previousView: UIView?

        for (icon, title) in menuItems {
            let menuItem = createMenuItem(icon: icon, title: title)
            menuItem.translatesAutoresizingMaskIntoConstraints = false
            menuCard.addSubview(menuItem)

            if let prev = previousView {
                menuItem.topAnchor.constraint(equalTo: prev.bottomAnchor).isActive = true
            } else {
                menuItem.topAnchor.constraint(equalTo: menuCard.topAnchor, constant: 8).isActive = true
            }
            menuItem.leadingAnchor.constraint(equalTo: menuCard.leadingAnchor, constant: 16).isActive = true
            menuItem.trailingAnchor.constraint(equalTo: menuCard.trailingAnchor, constant: -16).isActive = true

            previousView = menuItem
        }

        if let lastView = previousView {
            lastView.bottomAnchor.constraint(equalTo: menuCard.bottomAnchor, constant: -8).isActive = true
        }
    }

    private func createMenuItem(icon: String, title: String) -> UIView {
        let view = UIView()

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = UIColor(hex: "#9B8FE8")
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = UIColor(hex: "#6B6B6B")
        chevron.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(iconView)
        view.addSubview(titleLabel)
        view.addSubview(chevron)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            chevron.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chevron.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            view.heightAnchor.constraint(equalToConstant: 48)
        ])

        return view
    }

    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(levelLabel)
        contentView.addSubview(statsCard)
        contentView.addSubview(menuCard)
        contentView.addSubview(signOutButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 100),
            avatarView.heightAnchor.constraint(equalToConstant: 100),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            levelLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            levelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            statsCard.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 32),
            statsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            statsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            menuCard.topAnchor.constraint(equalTo: statsCard.bottomAnchor, constant: 24),
            menuCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            menuCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            signOutButton.topAnchor.constraint(equalTo: menuCard.bottomAnchor, constant: 24),
            signOutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            signOutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            signOutButton.heightAnchor.constraint(equalToConstant: 48),
            signOutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    @objc private func signOutTapped() {
        let alert = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sign out?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { _ in
            // Handle sign out
        })
        present(alert, animated: true)
    }
}