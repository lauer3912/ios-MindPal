import UIKit

class MirrorViewController: UIViewController {

    private let headerLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let chatCard = UIView()
    private let chatInput = UITextField()
    private let sendButton = UIButton(type: .system)
    private let messageBubble = UIView()
    private let messageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#0F0F14")
        title = "Mirror Self"

        headerLabel.text = "🪞 Mirror You"
        headerLabel.font = .systemFont(ofSize: 28, weight: .bold)
        headerLabel.textColor = .white
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.text = "Chat with an AI version of yourself"
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textColor = UIColor(hex: "#A1A1AA")
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        avatarView.backgroundColor = UIColor(hex: "#1C1C1E")
        avatarView.layer.cornerRadius = 50
        avatarView.layer.borderWidth = 3
        avatarView.layer.borderColor = UIColor(hex: "#9B8FE8").cgColor
        avatarView.translatesAutoresizingMaskIntoConstraints = false

        avatarLabel.text = "🧠"
        avatarLabel.font = .systemFont(ofSize: 48)
        avatarLabel.textAlignment = .center
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false

        chatCard.backgroundColor = UIColor(hex: "#1C1C1E")
        chatCard.layer.cornerRadius = 16
        chatCard.translatesAutoresizingMaskIntoConstraints = false

        messageBubble.backgroundColor = UIColor(hex: "#9B8FE8")
        messageBubble.layer.cornerRadius = 12
        messageBubble.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.text = "Hello! I'm your mirror. What are you thinking about today?"
        messageLabel.font = .systemFont(ofSize: 15, weight: .regular)
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        chatInput.placeholder = "Ask yourself something..."
        chatInput.backgroundColor = UIColor(hex: "#2C2C2E")
        chatInput.textColor = .white
        chatInput.layer.cornerRadius = 12
        chatInput.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        chatInput.leftViewMode = .always
        chatInput.translatesAutoresizingMaskIntoConstraints = false
        chatInput.attributedPlaceholder = NSAttributedString(
            string: "Ask yourself something...",
            attributes: [.foregroundColor: UIColor(hex: "#6B6B6B")]
        )

        sendButton.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        sendButton.tintColor = UIColor(hex: "#9B8FE8")
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        view.addSubview(headerLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        view.addSubview(chatCard)
        chatCard.addSubview(messageBubble)
        messageBubble.addSubview(messageLabel)
        chatCard.addSubview(chatInput)
        chatCard.addSubview(sendButton)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            avatarView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 100),
            avatarView.heightAnchor.constraint(equalToConstant: 100),

            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),

            chatCard.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 32),
            chatCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            chatCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            chatCard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            messageBubble.topAnchor.constraint(equalTo: chatCard.topAnchor, constant: 16),
            messageBubble.leadingAnchor.constraint(equalTo: chatCard.leadingAnchor, constant: 16),
            messageBubble.trailingAnchor.constraint(lessThanOrEqualTo: chatCard.trailingAnchor, constant: -60),

            messageLabel.topAnchor.constraint(equalTo: messageBubble.topAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: messageBubble.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: messageBubble.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: messageBubble.bottomAnchor, constant: -12),

            chatInput.topAnchor.constraint(equalTo: messageBubble.bottomAnchor, constant: 16),
            chatInput.leadingAnchor.constraint(equalTo: chatCard.leadingAnchor, constant: 16),
            chatInput.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            chatInput.heightAnchor.constraint(equalToConstant: 44),

            sendButton.centerYAnchor.constraint(equalTo: chatInput.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: chatCard.trailingAnchor, constant: -16),
            sendButton.widthAnchor.constraint(equalToConstant: 44),
            sendButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func sendTapped() {
        guard let text = chatInput.text, !text.isEmpty else { return }
        chatInput.text = ""
        messageLabel.text = "You said: \(text)\n\nLet me think about that..."
    }
}