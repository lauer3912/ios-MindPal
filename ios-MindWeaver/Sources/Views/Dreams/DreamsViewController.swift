import UIKit

class DreamsViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let inputCard = UIView()
    private let placeholderLabel = UILabel()
    private let analyzeButton = UIButton(type: .system)
    private let recentDreamsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#0F0F14")
        title = "Dream Analysis"

        headerLabel.text = "🌙 Dream Journal"
        headerLabel.font = .systemFont(ofSize: 28, weight: .bold)
        headerLabel.textColor = .white
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.text = "Record your dreams and get AI-powered interpretation"
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textColor = UIColor(hex: "#A1A1AA")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        inputCard.backgroundColor = UIColor(hex: "#1C1C1E")
        inputCard.layer.cornerRadius = 16
        inputCard.translatesAutoresizingMaskIntoConstraints = false

        placeholderLabel.text = "Describe your dream..."
        placeholderLabel.font = .systemFont(ofSize: 17, weight: .regular)
        placeholderLabel.textColor = UIColor(hex: "#6B6B6B")
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

        analyzeButton.setTitle("Analyze Dream", for: .normal)
        analyzeButton.setTitleColor(.white, for: .normal)
        analyzeButton.backgroundColor = UIColor(hex: "#9B8FE8")
        analyzeButton.layer.cornerRadius = 12
        analyzeButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        analyzeButton.translatesAutoresizingMaskIntoConstraints = false
        analyzeButton.addTarget(self, action: #selector(analyzeTapped), for: .touchUpInside)

        recentDreamsLabel.text = "Recent Dreams"
        recentDreamsLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        recentDreamsLabel.textColor = .white
        recentDreamsLabel.translatesAutoresizingMaskIntoConstraints = false

        setupInputCard()
        setupRecentDreams()
    }

    private func setupInputCard() {
        inputCard.addSubview(placeholderLabel)
        inputCard.addSubview(analyzeButton)

        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: inputCard.topAnchor, constant: 16),
            placeholderLabel.leadingAnchor.constraint(equalTo: inputCard.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: inputCard.trailingAnchor, constant: -16),

            analyzeButton.topAnchor.constraint(equalTo: placeholderLabel.bottomAnchor, constant: 16),
            analyzeButton.leadingAnchor.constraint(equalTo: inputCard.leadingAnchor, constant: 16),
            analyzeButton.trailingAnchor.constraint(equalTo: inputCard.trailingAnchor, constant: -16),
            analyzeButton.heightAnchor.constraint(equalToConstant: 48),
            analyzeButton.bottomAnchor.constraint(equalTo: inputCard.bottomAnchor, constant: -16)
        ])
    }

    private func setupRecentDreams() {
        let dreams = [
            ("Flying over mountains", "🌄 Flying", "2 days ago"),
            ("Chased by shadows", "👻 Chase", "4 days ago")
        ]

        var previousView: UIView = recentDreamsLabel

        for (title, emoji, time) in dreams {
            let card = createDreamCard(title: title, emoji: emoji, time: time)
            card.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(card)

            NSLayoutConstraint.activate([
                card.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 16),
                card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
                card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
            ])
            previousView = card
        }
    }

    private func createDreamCard(title: String, emoji: String, time: String) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor(hex: "#1C1C1E")
        card.layer.cornerRadius = 12

        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = .systemFont(ofSize: 24)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let timeLabel = UILabel()
        timeLabel.text = time
        timeLabel.font = .systemFont(ofSize: 12, weight: .regular)
        timeLabel.textColor = UIColor(hex: "#6B6B6B")
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(emojiLabel)
        card.addSubview(titleLabel)
        card.addSubview(timeLabel)

        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            emojiLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 40),

            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),

            timeLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            timeLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),

            card.heightAnchor.constraint(equalToConstant: 64)
        ])

        return card
    }

    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(inputCard)
        contentView.addSubview(recentDreamsLabel)

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

            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),

            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            inputCard.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            inputCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            inputCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            recentDreamsLabel.topAnchor.constraint(equalTo: inputCard.bottomAnchor, constant: 32),
            recentDreamsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24)
        ])
    }

    @objc private func analyzeTapped() {
        let alert = UIAlertController(title: "🔮 Analyzing...", message: "AI is interpreting your dream", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}