import UIKit

class ChallengesViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let challengeCard = UIView()
    private let categorySegment = UISegmentedControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#0F0F14")
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Challenges"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "star.fill"),
            style: .plain,
            target: self,
            action: #selector(showStreak)
        )

        titleLabel.text = "AI Prediction Challenge"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.text = "Can you think differently?"
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = UIColor(hex: "#A1A1AA")
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        categorySegment.insertSegment(withTitle: "All", at: 0, animated: false)
        categorySegment.insertSegment(withTitle: "Colors", at: 1, animated: false)
        categorySegment.insertSegment(withTitle: "Objects", at: 2, animated: false)
        categorySegment.insertSegment(withTitle: "Emotions", at: 3, animated: false)
        categorySegment.selectedSegmentIndex = 0
        categorySegment.translatesAutoresizingMaskIntoConstraints = false
        categorySegment.backgroundColor = UIColor(hex: "#1C1C1E")
        categorySegment.selectedSegmentTintColor = UIColor(hex: "#9B8FE8")

        challengeCard.backgroundColor = UIColor(hex: "#1C1C1E")
        challengeCard.layer.cornerRadius = 16
        challengeCard.layer.borderWidth = 1
        challengeCard.layer.borderColor = UIColor(hex: "#9B8FE8").cgColor
        challengeCard.translatesAutoresizingMaskIntoConstraints = false

        setupChallengeCard()
    }

    private func setupChallengeCard() {
        let predictionLabel = UILabel()
        predictionLabel.text = "You are thinking about..."
        predictionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        predictionLabel.textColor = UIColor(hex: "#A1A1AA")
        predictionLabel.textAlignment = .center
        predictionLabel.translatesAutoresizingMaskIntoConstraints = false

        let answerLabel = UILabel()
        answerLabel.text = "🧠 A RED APPLE"
        answerLabel.font = .systemFont(ofSize: 24, weight: .bold)
        answerLabel.textColor = UIColor(hex: "#9B8FE8")
        answerLabel.textAlignment = .center
        answerLabel.translatesAutoresizingMaskIntoConstraints = false

        let confidenceLabel = UILabel()
        confidenceLabel.text = "AI Confidence: 87%"
        confidenceLabel.font = .systemFont(ofSize: 11, weight: .regular)
        confidenceLabel.textColor = UIColor(hex: "#6EE7B7")
        confidenceLabel.textAlignment = .center
        confidenceLabel.translatesAutoresizingMaskIntoConstraints = false

        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.spacing = 16
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        let denyButton = UIButton(type: .system)
        denyButton.setTitle("Deny", for: .normal)
        denyButton.setTitleColor(.white, for: .normal)
        denyButton.backgroundColor = UIColor(hex: "#EF4444")
        denyButton.layer.cornerRadius = 12
        denyButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        denyButton.addTarget(self, action: #selector(denyTapped), for: .touchUpInside)

        let acceptButton = UIButton(type: .system)
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.backgroundColor = UIColor(hex: "#6EE7B7")
        acceptButton.layer.cornerRadius = 12
        acceptButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)

        buttonStack.addArrangedSubview(denyButton)
        buttonStack.addArrangedSubview(acceptButton)

        challengeCard.addSubview(predictionLabel)
        challengeCard.addSubview(answerLabel)
        challengeCard.addSubview(confidenceLabel)
        challengeCard.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            predictionLabel.topAnchor.constraint(equalTo: challengeCard.topAnchor, constant: 24),
            predictionLabel.centerXAnchor.constraint(equalTo: challengeCard.centerXAnchor),

            answerLabel.topAnchor.constraint(equalTo: predictionLabel.bottomAnchor, constant: 16),
            answerLabel.centerXAnchor.constraint(equalTo: challengeCard.centerXAnchor),

            confidenceLabel.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 8),
            confidenceLabel.centerXAnchor.constraint(equalTo: challengeCard.centerXAnchor),

            buttonStack.topAnchor.constraint(equalTo: confidenceLabel.bottomAnchor, constant: 24),
            buttonStack.leadingAnchor.constraint(equalTo: challengeCard.leadingAnchor, constant: 24),
            buttonStack.trailingAnchor.constraint(equalTo: challengeCard.trailingAnchor, constant: -24),
            buttonStack.heightAnchor.constraint(equalToConstant: 48),
            buttonStack.bottomAnchor.constraint(equalTo: challengeCard.bottomAnchor, constant: -24)
        ])
    }

    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(categorySegment)
        contentView.addSubview(challengeCard)

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

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),

            categorySegment.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            categorySegment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            categorySegment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            challengeCard.topAnchor.constraint(equalTo: categorySegment.bottomAnchor, constant: 32),
            challengeCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            challengeCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            challengeCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    @objc private func denyTapped() {
        showResult(correct: true)
    }

    @objc private func acceptTapped() {
        showResult(correct: false)
    }

    @objc private func showStreak() {
        let alert = UIAlertController(title: "🔥 Streak", message: "Current streak: 5 days\nTotal points: 2,450", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showResult(correct: Bool) {
        let title = correct ? "✅ Correct!" : "❌ Wrong!"
        let message = correct ? "You denied the prediction correctly!" : "You accepted the prediction."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Next", style: .default) { [weak self] _ in
            self?.challengeCard.removeFromSuperview()
            self?.setupChallengeCard()
            self?.contentView.addSubview(self?.challengeCard ?? UIView())
        })
        present(alert, animated: true)
    }
}