import UIKit
import SnapKit

class EntryViewController: UIViewController {
    var onSave: (() -> Void)?

    private let moodSelector = UIStackView()
    private let textView = UITextView()
    private let saveButton = UIButton(type: .system)

    private var selectedMood: String = "😊"

    private let moods: [(emoji: String, color: UIColor)] = [
        ("😊", Theme.Colors.moodHappy),
        ("😌", Theme.Colors.moodCalm),
        ("😐", Theme.Colors.moodNeutral),
        ("😔", Theme.Colors.moodSad),
        ("😰", Theme.Colors.moodAnxious),
        ("😤", Theme.Colors.moodAngry),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.adaptiveBgPrimary

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))

        let titleLabel = UILabel()
        titleLabel.text = "New Entry"
        titleLabel.font = Theme.Typography.heading1()
        titleLabel.textColor = Theme.Colors.adaptiveTextPrimary

        let moodLabel = UILabel()
        moodLabel.text = "How are you feeling?"
        moodLabel.font = Theme.Typography.body()
        moodLabel.textColor = Theme.Colors.adaptiveTextSecondary

        moodSelector.axis = .horizontal
        moodSelector.distribution = .equalSpacing
        moodSelector.spacing = Theme.Spacing.md

        for (emoji, color) in moods {
            let btn = UIButton(type: .system)
            btn.setTitle(emoji, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 28)
            btn.backgroundColor = emoji == selectedMood ? color.withAlphaComponent(0.3) : color.withAlphaComponent(0.1)
            btn.layer.cornerRadius = 24
            btn.tag = moods.firstIndex(where: { $0.emoji == emoji }) ?? 0
            btn.addTarget(self, action: #selector(moodSelected(_:)), for: .touchUpInside)
            moodSelector.addArrangedSubview(btn)
        }

        textView.font = Theme.Typography.body()
        textView.textColor = Theme.Colors.adaptiveTextPrimary
        textView.backgroundColor = Theme.Colors.adaptiveCardBg
        textView.layer.cornerRadius = Theme.CornerRadius.card
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        textView.accessibilityLabel = "Journal entry text"

        view.addSubview(titleLabel)
        view.addSubview(moodLabel)
        view.addSubview(moodSelector)
        view.addSubview(textView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }
        moodLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.xl)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }
        moodSelector.snp.makeConstraints { make in
            make.top.equalTo(moodLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(48)
        }
        textView.snp.makeConstraints { make in
            make.top.equalTo(moodSelector.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-Theme.Spacing.lg)
        }
    }

    @objc private func moodSelected(_ sender: UIButton) {
        selectedMood = moods[sender.tag].emoji
        for case let btn as UIButton in moodSelector.arrangedSubviews {
            let color = moods[btn.tag].color
            btn.backgroundColor = btn.tag == sender.tag ? color.withAlphaComponent(0.3) : color.withAlphaComponent(0.1)
        }
    }

    @objc private func cancelTapped() { dismiss(animated: true) }
    @objc private func saveTapped() {
        onSave?()
        dismiss(animated: true)
    }
}