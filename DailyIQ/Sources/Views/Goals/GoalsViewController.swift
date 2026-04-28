import UIKit
import SnapKit

class GoalsViewController: UIViewController {

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Goals"
        label.font = Theme.Typography.heading1()
        label.textColor = Theme.Colors.txtPrimary
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()

    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        btn.tintColor = Theme.Colors.accentPrimary
        btn.addTarget(self, action: #selector(addGoalTapped), for: .touchUpInside)
        btn.accessibilityLabel = "Add new goal"
        btn.accessibilityHint = "Double tap to add a new goal"
        btn.accessibilityTraits = .button
        return btn
    }()

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()

    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = Theme.Spacing.md
        return sv
    }()

    private var goals: [Goal] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSampleGoals()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.bgPrimary

        [headerLabel, addButton, scrollView].forEach { view.addSubview($0) }
        scrollView.addSubview(stackView)

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.trailing.equalToSuperview().offset(-Theme.Spacing.lg)
            make.size.equalTo(44)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.bottom.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Theme.Spacing.lg)
            make.width.equalToSuperview().offset(-Theme.Spacing.lg * 2)
        }
    }

    private func loadSampleGoals() {
        goals = [
            Goal(title: "Launch DailyIQ App", targetDate: Calendar.current.date(byAdding: .month, value: 1, to: Date())!, progress: 0.65),
            Goal(title: "Reach 100 paying users", targetDate: Calendar.current.date(byAdding: .month, value: 3, to: Date())!, progress: 0.30),
            Goal(title: "Write 20 blog posts", targetDate: Calendar.current.date(byAdding: .month, value: 2, to: Date())!, progress: 0.55),
        ]

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for goal in goals {
            let card = GoalCard(goal: goal)
            stackView.addArrangedSubview(card)
        }
    }

    @objc private func addGoalTapped() {
        // Add goal logic
    }
}

class GoalCard: UIView {

    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let progressBar = UIProgressView(progressViewStyle: .default)
    private let progressLabel = UILabel()

    init(goal: Goal) {
        super.init(frame: .zero)
        setupUI()
        configure(with: goal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = Theme.Colors.bgSecondary
        layer.cornerRadius = Theme.CornerRadius.card

        titleLabel.font = Theme.Typography.heading2()
        titleLabel.textColor = Theme.Colors.txtPrimary
        titleLabel.accessibilityTraits = .header
        titleLabel.isAccessibilityElement = true

        dateLabel.font = Theme.Typography.caption()
        dateLabel.textColor = Theme.Colors.txtSecondary

        progressBar.progressTintColor = Theme.Colors.accentPrimary
        progressBar.trackTintColor = Theme.Colors.bgTertiary

        progressLabel.font = Theme.Typography.caption()
        progressLabel.textColor = Theme.Colors.accentPrimary

        [titleLabel, dateLabel, progressBar, progressLabel].forEach { addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
            make.trailing.equalToSuperview().offset(-Theme.Spacing.md)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.xs)
            make.leading.equalToSuperview().offset(Theme.Spacing.md)
        }

        progressBar.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.md)
            make.height.equalTo(8)
        }

        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(Theme.Spacing.xs)
            make.trailing.equalToSuperview().offset(-Theme.Spacing.md)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.md)
        }
    }

    private func configure(with goal: Goal) {
        titleLabel.text = goal.title
        titleLabel.accessibilityLabel = "Goal: \(goal.title)"
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = "Target: \(formatter.string(from: goal.targetDate))"
        dateLabel.accessibilityLabel = "Target date: \(formatter.string(from: goal.targetDate))"
        progressBar.progress = Float(goal.progress)
        progressBar.accessibilityLabel = "Progress: \(Int(goal.progress * 100)) percent"
        progressLabel.text = "\(Int(goal.progress * 100))%"
        progressLabel.accessibilityLabel = "\(Int(goal.progress * 100)) percent complete"
    }
}
