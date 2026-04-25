import UIKit
import SnapKit

class GrowthViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Growth"
        label.font = Theme.Typography.heading1()
        label.textColor = Theme.Colors.adaptiveTextPrimary
        return label
    }()

    private let streakCard: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Colors.accentPrimary.withAlphaComponent(0.1)
        view.layer.cornerRadius = Theme.CornerRadius.card
        view.layer.borderWidth = 1
        view.layer.borderColor = Theme.Colors.accentPrimary.withAlphaComponent(0.3).cgColor
        return view
    }()

    private let achievementsCard: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Colors.adaptiveCardBg
        view.layer.cornerRadius = Theme.CornerRadius.card
        return view
    }()

    private let milestonesCard: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Colors.adaptiveCardBg
        view.layer.cornerRadius = Theme.CornerRadius.card
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        populateData()
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.adaptiveBgPrimary
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(streakCard)
        contentView.addSubview(achievementsCard)
        contentView.addSubview(milestonesCard)

        setupStreakCard()
        setupAchievementsCard()
        setupMilestonesCard()
    }

    private func setupStreakCard() {
        let flameLabel = UILabel()
        flameLabel.text = "🔥"
        flameLabel.font = .systemFont(ofSize: 40)

        let countLabel = UILabel()
        countLabel.text = "7"
        countLabel.font = .systemFont(ofSize: 48, weight: .bold)
        countLabel.textColor = Theme.Colors.accentPrimary

        let dayLabel = UILabel()
        dayLabel.text = "day streak"
        dayLabel.font = Theme.Typography.body()
        dayLabel.textColor = Theme.Colors.adaptiveTextSecondary

        let messageLabel = UILabel()
        messageLabel.text = "Keep it up! Your journal is growing."
        messageLabel.font = Theme.Typography.caption()
        messageLabel.textColor = Theme.Colors.accentSecondary

        streakCard.addSubview(flameLabel)
        streakCard.addSubview(countLabel)
        streakCard.addSubview(dayLabel)
        streakCard.addSubview(messageLabel)

        flameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(flameLabel)
            make.leading.equalTo(flameLabel.snp.trailing).offset(Theme.Spacing.md)
        }
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(countLabel)
            make.leading.equalTo(countLabel.snp.trailing).offset(Theme.Spacing.sm)
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(Theme.Spacing.sm)
            make.leading.equalTo(countLabel)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.lg)
        }
    }

    private func setupAchievementsCard() {
        let titleLabel = UILabel()
        titleLabel.text = "Achievements"
        titleLabel.font = Theme.Typography.heading3()
        titleLabel.textColor = Theme.Colors.adaptiveTextPrimary

        let badges = [
            ("🌟", "First Entry", true),
            ("📝", "Week Warrior", true),
            ("🔥", "7-Day Streak", true),
            ("🧠", "Self-Aware", false),
        ]

        let badgesStack = UIStackView()
        badgesStack.axis = .horizontal
        badgesStack.distribution = .fillEqually
        badgesStack.spacing = Theme.Spacing.md

        for (emoji, name, unlocked) in badges {
            let badgeView = UIView()
            let emojiLabel = UILabel()
            emojiLabel.text = emoji
            emojiLabel.font = .systemFont(ofSize: 28)
            emojiLabel.alpha = unlocked ? 1.0 : 0.3

            let nameLabel = UILabel()
            nameLabel.text = name
            nameLabel.font = Theme.Typography.caption()
            nameLabel.textColor = Theme.Colors.adaptiveTextSecondary
            nameLabel.textAlignment = .center

            badgeView.addSubview(emojiLabel)
            badgeView.addSubview(nameLabel)

            emojiLabel.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
            }
            nameLabel.snp.makeConstraints { make in
                make.top.equalTo(emojiLabel.snp.bottom).offset(4)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
            }

            badgeView.accessibilityLabel = "\(name) badge, \(unlocked ? "unlocked" : "locked")"
            badgesStack.addArrangedSubview(badgeView)
        }

        achievementsCard.addSubview(titleLabel)
        achievementsCard.addSubview(badgesStack)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
        }
        badgesStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.md)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.md)
        }
    }

    private func setupMilestonesCard() {
        let titleLabel = UILabel()
        titleLabel.text = "Upcoming Milestones"
        titleLabel.font = Theme.Typography.heading3()
        titleLabel.textColor = Theme.Colors.adaptiveTextPrimary

        let milestones = [
            ("14-Day Streak", "🔥", 0.5),
            ("30 Entries", "📖", 0.35),
            ("Mood Master", "🧘", 0.0),
        ]

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Theme.Spacing.md

        for (name, emoji, progress) in milestones {
            let itemView = UIView()

            let emojiLabel = UILabel()
            emojiLabel.text = emoji
            emojiLabel.font = .systemFont(ofSize: 20)

            let nameLabel = UILabel()
            nameLabel.text = name
            nameLabel.font = Theme.Typography.body()
            nameLabel.textColor = Theme.Colors.adaptiveTextPrimary

            let progressBar = UIView()
            progressBar.backgroundColor = Theme.Colors.adaptiveBgSecondary
            progressBar.layer.cornerRadius = 4

            let progressFill = UIView()
            progressFill.backgroundColor = Theme.Colors.accentSecondary
            progressFill.layer.cornerRadius = 4

            progressBar.addSubview(progressFill)
            progressFill.snp.makeConstraints { make in
                make.leading.top.bottom.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(progress)
            }

            itemView.addSubview(emojiLabel)
            itemView.addSubview(nameLabel)
            itemView.addSubview(progressBar)

            emojiLabel.snp.makeConstraints { make in
                make.leading.centerY.equalToSuperview()
            }
            nameLabel.snp.makeConstraints { make in
                make.leading.equalTo(emojiLabel.snp.trailing).offset(Theme.Spacing.sm)
                make.top.equalToSuperview()
            }
            progressBar.snp.makeConstraints { make in
                make.leading.equalTo(nameLabel)
                make.top.equalTo(nameLabel.snp.bottom).offset(4)
                make.trailing.equalToSuperview()
                make.height.equalTo(8)
                make.bottom.equalToSuperview()
            }

            stackView.addArrangedSubview(itemView)
        }

        milestonesCard.addSubview(titleLabel)
        milestonesCard.addSubview(stackView)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.md)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.md)
        }
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }
        streakCard.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }
        achievementsCard.snp.makeConstraints { make in
            make.top.equalTo(streakCard.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }
        milestonesCard.snp.makeConstraints { make in
            make.top.equalTo(achievementsCard.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.xxl)
        }
    }

    private func populateData() {
        // Data is populated in setup methods
    }
}