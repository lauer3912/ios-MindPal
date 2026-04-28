import UIKit
import SnapKit

class AIChatViewController: UIViewController {

    // MARK: - UI Components

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "AI Assistant"
        label.font = Theme.Typography.heading1()
        label.textColor = Theme.Colors.txtPrimary
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = Theme.Colors.bgPrimary
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        tv.keyboardDismissMode = .interactive
        return tv
    }()

    private lazy var inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Colors.bgSecondary
        return view
    }()

    private lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Ask AI anything..."
        tf.font = Theme.Typography.body()
        tf.textColor = Theme.Colors.txtPrimary
        tf.backgroundColor = Theme.Colors.bgTertiary
        tf.layer.cornerRadius = Theme.CornerRadius.button
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.rightViewMode = .always
        tf.returnKeyType = .send
        tf.delegate = self
        tf.accessibilityLabel = "Message input"
        tf.accessibilityHint = "Type your message to AI assistant"
        return tf
    }()

    private lazy var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        btn.tintColor = Theme.Colors.accentPrimary
        btn.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        btn.accessibilityLabel = "Send message"
        btn.accessibilityHint = "Double tap to send your message"
        return btn
    }()

    private lazy var quickActionsStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = Theme.Spacing.sm
        sv.distribution = .fillEqually
        return sv
    }()

    private var messages: [ChatMessage] = []
    private let aiService = AISchedulingService.shared

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupQuickActions()
        loadWelcomeMessage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = Theme.Colors.bgPrimary

        [headerLabel, tableView, inputContainerView].forEach { view.addSubview($0) }
        inputContainerView.addSubview(inputTextField)
        inputContainerView.addSubview(sendButton)

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(inputContainerView.snp.top)
        }

        inputContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }

        inputTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.sm)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
            make.height.equalTo(44)
        }

        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(inputTextField)
            make.leading.equalTo(inputTextField.snp.trailing).offset(Theme.Spacing.sm)
            make.trailing.equalToSuperview().offset(-Theme.Spacing.lg)
            make.size.equalTo(44)
        }
    }

    private func setupQuickActions() {
        let actions = [
            ("Schedule", "calendar.badge.plus"),
            ("Optimize", "wand.and.stars"),
            ("Insights", "chart.bar.fill"),
            ("Help", "questionmark.circle")
        ]

        for (title, icon) in actions {
            let button = createQuickActionButton(title: title, icon: icon)
            quickActionsStack.addArrangedSubview(button)
        }

        view.addSubview(quickActionsStack)
        quickActionsStack.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(Theme.Spacing.sm)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(36)
        }
    }

    private func createQuickActionButton(title: String, icon: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setImage(UIImage(systemName: icon), for: .normal)
        btn.titleLabel?.font = Theme.Typography.caption()
        btn.tintColor = Theme.Colors.accentPrimary
        btn.backgroundColor = Theme.Colors.accentPrimary.withAlphaComponent(0.1)
        btn.layer.cornerRadius = Theme.CornerRadius.small
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        btn.addTarget(self, action: #selector(quickActionTapped(_:)), for: .touchUpInside)
        btn.accessibilityLabel = title
        btn.tag = ["Schedule", "Optimize", "Insights", "Help"].firstIndex(of: title) ?? 0
        return btn
    }

    private func loadWelcomeMessage() {
        let welcome = ChatMessage(
            content: "Hello! I'm your AI scheduling assistant. I can help you:\n• Optimize your daily schedule\n• Suggest best time slots for tasks\n• Predict busy periods\n• Generate daily reports\n\nWhat would you like help with today?",
            isFromUser: false,
            timestamp: Date()
        )
        messages.append(welcome)
        tableView.reloadData()
    }

    // MARK: - Actions

    @objc private func sendTapped() {
        guard let text = inputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else { return }

        addUserMessage(text)
        inputTextField.text = ""

        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.generateAIResponse(for: text)
        }
    }

    @objc private func quickActionTapped(_ sender: UIButton) {
        let actions = [
            "Schedule a new task for me",
            "Optimize my schedule for higher productivity",
            "Show my productivity insights for this week",
            "Help me with scheduling"
        ]
        let action = actions[sender.tag]
        addUserMessage(action)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.generateAIResponse(for: action)
        }
    }

    private func addUserMessage(_ text: String) {
        let message = ChatMessage(content: text, isFromUser: true, timestamp: Date())
        messages.append(message)
        tableView.reloadData()
        scrollToBottom()
    }

    private func generateAIResponse(for userMessage: String) {
        let response: String

        let lowerMessage = userMessage.lowercased()

        if lowerMessage.contains("schedule") || lowerMessage.contains("task") || lowerMessage.contains("plan") {
            response = generateScheduleResponse(userMessage)
        } else if lowerMessage.contains("optimize") || lowerMessage.contains("productive") {
            response = generateOptimizeResponse()
        } else if lowerMessage.contains("insight") || lowerMessage.contains("report") || lowerMessage.contains("stats") {
            response = generateInsightsResponse()
        } else if lowerMessage.contains("best time") || lowerMessage.contains("peak") {
            response = generateBestTimeResponse()
        } else if lowerMessage.contains("busy") || lowerMessage.contains("predict") {
            response = generateBusyPredictionResponse()
        } else {
            response = generateGeneralResponse(userMessage)
        }

        let aiMessage = ChatMessage(content: response, isFromUser: false, timestamp: Date())
        messages.append(aiMessage)
        tableView.reloadData()
        scrollToBottom()
    }

    private func generateScheduleResponse(_ message: String) -> String {
        return "I can help you schedule tasks! Here's what I recommend:\n\n1. **Morning Peak (9-11 AM)**: Schedule high-priority, high-energy tasks like project planning or critical decisions.\n\n2. **Afternoon (2-4 PM)**: Great for meetings and collaborative work.\n\n3. **Evening Wind-down**: Light tasks like reading or learning.\n\nWould you like me to create a task now? Just say something like 'Add deep work session at 2pm for 2 hours' and I'll schedule it!"
    }

    private func generateOptimizeResponse() -> String {
        let peakHours = aiService.detectPeakHours()
        let highHours = peakHours.high.map { "\($0):00" }.joined(separator: ", ")

        return "I've analyzed your schedule and here's my optimization suggestion:\n\n🌟 **Peak Energy Hours**: \(highHours)\n\n**Recommendations:**\n• Move P0/P1 tasks to morning peak hours\n• Add 10-min breaks between focused blocks\n• Schedule meetings after 2 PM\n• Reserve 9-11 AM for deep work\n\nShall I regenerate your today's schedule based on this?"
    }

    private func generateInsightsResponse() -> String {
        return "📊 **Your Weekly Insights**\n\n• **Tasks Completed**: 12/15 (80%)\n• **Total Focus Time**: 18.5 hours\n• **Completion Rate**: 80%\n• **Best Day**: Wednesday (95%)\n• **Peak Hour**: 10 AM\n\n**AI Suggestions:**\n1. Your focus drops after lunch - consider shorter tasks\n2. Wednesday is your most productive day - plan important work\n\nWant me to generate a detailed report?"
    }

    private func generateBestTimeResponse() -> String {
        return "⏰ **Best Time Slots**\n\nBased on your energy patterns:\n\n**High Energy (Best for Important Tasks)**\n• 9:00 AM - 11:00 AM\n• 3:00 PM - 5:00 PM\n\n**Medium Energy (Good for Regular Work)**\n• 11:00 AM - 12:00 PM\n• 2:00 PM - 3:00 PM\n\n**Low Energy (Best for Admin/Email)**\n• 1:00 PM - 2:00 PM (post-lunch dip)\n• 7:00 PM - 8:00 PM\n\nShall I schedule your pending tasks in these slots?"
    }

    private func generateBusyPredictionResponse() -> String {
        return "🔮 **Busy Time Prediction**\n\nBased on your patterns, I predict:\n\n**High Busy Periods:**\n• Monday morning (meeting heavy)\n• Wednesday afternoon (project reviews)\n• Friday afternoon (wrap-up rush)\n\n**Light Periods (Good for Deep Work):**\n• Tuesday morning\n• Thursday all day\n\nI'll automatically avoid scheduling during your busy periods. Want me to block focus time during your light periods?"
    }

    private func generateGeneralResponse(_ message: String) -> String {
        return "I understand you want help with: \"\(message)\"\n\nI can assist with:\n\n• 📅 **Scheduling** - Create and optimize your daily schedule\n• 🎯 **Task Management** - Break down complex tasks\n• 📊 **Insights** - Generate productivity reports\n• ⏰ **Time Optimization** - Find your best working hours\n• 🔮 **Predictions** - Anticipate busy periods\n\nTry saying:\n• \"Schedule a 2-hour focus block tomorrow\"\n• \"What's my best time for creative work?\"\n• \"Show my weekly productivity report\""
    }

    private func scrollToBottom() {
        guard messages.count > 0 else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - UITableViewDelegate & DataSource

extension AIChatViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.configure(with: messages[indexPath.row])
        return cell
    }
}

// MARK: - UITextFieldDelegate

extension AIChatViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTapped()
        return true
    }
}

// MARK: - ChatMessage Model

struct ChatMessage {
    let id = UUID()
    let content: String
    let isFromUser: Bool
    let timestamp: Date
}

// MARK: - MessageCell

class MessageCell: UITableViewCell {

    private let bubbleView = UIView()
    private let messageLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        bubbleView.layer.cornerRadius = Theme.CornerRadius.card
        messageLabel.font = Theme.Typography.body()
        messageLabel.numberOfLines = 0

        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)

        bubbleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.sm)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.sm)
            make.width.lessThanOrEqualTo(280)
        }

        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Theme.Spacing.md)
        }
    }

    func configure(with message: ChatMessage) {
        messageLabel.text = message.content

        if message.isFromUser {
            bubbleView.backgroundColor = Theme.Colors.accentPrimary
            messageLabel.textColor = .white
            bubbleView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(Theme.Spacing.sm)
                make.bottom.equalToSuperview().offset(-Theme.Spacing.sm)
                make.trailing.equalToSuperview().offset(-Theme.Spacing.lg)
                make.width.lessThanOrEqualTo(280)
            }
        } else {
            bubbleView.backgroundColor = Theme.Colors.bgSecondary
            messageLabel.textColor = Theme.Colors.txtPrimary
            bubbleView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(Theme.Spacing.sm)
                make.bottom.equalToSuperview().offset(-Theme.Spacing.sm)
                make.leading.equalToSuperview().offset(Theme.Spacing.lg)
                make.width.lessThanOrEqualTo(280)
            }
        }

        isAccessibilityElement = true
        accessibilityLabel = message.isFromUser ? "You said: \(message.content)" : "AI assistant said: \(message.content)"
    }
}