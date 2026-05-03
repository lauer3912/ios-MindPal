import UIKit

class HomeViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MindWeaver"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "What will you think next?"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(hex: "#A1A1AA")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let predictionCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#1C1C1E")
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let predictionLabel: UILabel = {
        let label = UILabel()
        label.text = "AI is thinking..."
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "#9B8FE8")
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let denyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Deny", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "#6EE7B7")
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#0F0F14")
        navigationController?.navigationBar.isHidden = true

        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(predictionCard)
        predictionCard.addSubview(predictionLabel)
        predictionCard.addSubview(acceptButton)
        predictionCard.addSubview(denyButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            predictionCard.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 48),
            predictionCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            predictionCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            predictionLabel.topAnchor.constraint(equalTo: predictionCard.topAnchor, constant: 48),
            predictionLabel.centerXAnchor.constraint(equalTo: predictionCard.centerXAnchor),

            acceptButton.topAnchor.constraint(equalTo: predictionLabel.bottomAnchor, constant: 32),
            acceptButton.leadingAnchor.constraint(equalTo: predictionCard.leadingAnchor, constant: 24),
            acceptButton.widthAnchor.constraint(equalToConstant: 120),
            acceptButton.heightAnchor.constraint(equalToConstant: 48),
            acceptButton.bottomAnchor.constraint(equalTo: predictionCard.bottomAnchor, constant: -24),

            denyButton.topAnchor.constraint(equalTo: predictionLabel.bottomAnchor, constant: 32),
            denyButton.trailingAnchor.constraint(equalTo: predictionCard.trailingAnchor, constant: -24),
            denyButton.widthAnchor.constraint(equalToConstant: 120),
            denyButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}