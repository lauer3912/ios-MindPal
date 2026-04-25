import UIKit
import SnapKit

class JournalViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "How are you feeling?"
        label.font = Theme.Typography.heading1()
        label.textColor = Theme.Colors.adaptiveTextPrimary
        return label
    }()

    private let moodStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.spacing = Theme.Spacing.md
        return sv
    }()

    private let quickEntryCard: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Colors.adaptiveCardBg
        view.layer.cornerRadius = Theme.CornerRadius.card
        return view
    }()

    private let quickEntryLabel: UILabel = {
        let label = UILabel()
        label.text = "Start writing your thoughts..."
        label.font = Theme.Typography.body()
        label.textColor = Theme.Colors.adaptiveTextSecondary
        label.isUserInteractionEnabled = true
        return label
    }()

    private let recentLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Entries"
        label.font = Theme.Typography.heading2()
        label.textColor = Theme.Colors.adaptiveTextPrimary
        return label
    }()

    private let entriesStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = Theme.Spacing.md
        return sv
    }()

    private let moods: [(emoji: String, label: String, color: UIColor)] = [
        ("😊", "Happy", Theme.Colors.moodHappy),
        ("😌", "Calm", Theme.Colors.moodCalm),
        ("😐", "Neutral", Theme.Colors.moodNeutral),
        ("😔", "Sad", Theme.Colors.moodSad),
        ("😰", "Anxious", Theme.Colors.moodAnxious),
        ("😤", "Angry", Theme.Colors.moodAngry),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadEntries()
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.adaptiveBgPrimary
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(moodStackView)
        contentView.addSubview(quickEntryCard)
        quickEntryCard.addSubview(quickEntryLabel)
        contentView.addSubview(recentLabel)
        contentView.addSubview(entriesStackView)

        for (emoji, _, color) in moods {
            let button = UIButton(type: .system)
            button.setTitle(emoji, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 28)
            button.backgroundColor = color.withAlphaComponent(0.15)
            button.layer.cornerRadius = 26
            button.accessibilityLabel = "\(emoji) mood"
            button.addTarget(self, action: #selector(moodTapped(_:)), for: .touchUpInside)
            moodStackView.addArrangedSubview(button)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(quickEntryTapped))
        quickEntryCard.addGestureRecognizer(tap)
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
        moodStackView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(52)
        }
        quickEntryCard.snp.makeConstraints { make in
            make.top.equalTo(moodStackView.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(100)
        }
        quickEntryLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        recentLabel.snp.makeConstraints { make in
            make.top.equalTo(quickEntryCard.snp.bottom).offset(Theme.Spacing.xl)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }
        entriesStackView.snp.makeConstraints { make in
            make.top.equalTo(recentLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.xxl)
        }
    }

    private func loadEntries() {
        let demoEntries = [
            ("Morning Reflection", "Today I felt grateful for the small things...", "😊", "Today, 9:30 AM"),
            ("Work Challenge", "Had a difficult conversation with my manager...", "😰", "Yesterday, 6:15 PM"),
            ("Gratitude List", "Three things I'm thankful for this week...", "😌", "Apr 23, 8:45 PM"),
        ]
        for (title, preview, mood, date) in demoEntries {
            let card = createEntryCard(title: title, preview: preview, mood: mood, date: date)
            entriesStackView.addArrangedSubview(card)
        }
    }

    private func createEntryCard(title: String, preview: String, mood: String, date: String) -> UIView {
        let card = UIView()
        card.backgroundColor = Theme.Colors.adaptiveCardBg
        card.layer.cornerRadius = Theme.CornerRadius.card
        card.accessibilityLabel = "Journal entry: \(title)"

        let moodLabel = UILabel()
        moodLabel.text = mood
        moodLabel.font = .systemFont(ofSize: 24)

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Theme.Typography.bodyBold()
        titleLabel.textColor = Theme.Colors.adaptiveTextPrimary

        let previewLabel = UILabel()
        previewLabel.text = preview
        previewLabel.font = Theme.Typography.caption()
        previewLabel.textColor = Theme.Colors.adaptiveTextSecondary
        previewLabel.numberOfLines = 2

        let dateLabel = UILabel()
        dateLabel.text = date
        dateLabel.font = Theme.Typography.caption()
        dateLabel.textColor = Theme.Colors.adaptiveTextSecondary

        card.addSubview(moodLabel)
        card.addSubview(titleLabel)
        card.addSubview(previewLabel)
        card.addSubview(dateLabel)

        moodLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Theme.Spacing.md)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.md)
            make.leading.equalTo(moodLabel.snp.trailing).offset(Theme.Spacing.md)
            make.trailing.equalToSuperview().offset(-Theme.Spacing.md)
        }
        previewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.xs)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-Theme.Spacing.md)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(previewLabel.snp.bottom).offset(Theme.Spacing.xs)
            make.leading.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.md)
        }

        return card
    }

    @objc private func moodTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                sender.transform = .identity
            }
        }
    }

    @objc private func quickEntryTapped() {
        let entryVC = EntryViewController()
        entryVC.onSave = { [weak self] in
            self?.loadEntries()
        }
        let nav = UINavigationController(rootViewController: entryVC)
        present(nav, animated: true)
    }
}