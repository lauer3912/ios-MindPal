import UIKit
import SnapKit

class GoalsViewController: UIViewController {

    private let goalService = GoalService.shared

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

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No goals yet.\nTap + to create your first goal."
        label.font = Theme.Typography.body()
        label.textColor = Theme.Colors.txtSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.accessibilityLabel = "No goals created yet. Tap the add button to create your first goal."
        return label
    }()

    private var goals: [Goal] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        loadGoals()
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.bgPrimary

        [headerLabel, addButton, scrollView, emptyStateLabel].forEach { view.addSubview($0) }
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

        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalTo(scrollView)
        }

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Theme.Spacing.lg)
            make.width.equalToSuperview().offset(-Theme.Spacing.lg * 2)
        }
    }

    private func loadGoals() {
        goals = goalService.getActiveGoals()

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if goals.isEmpty {
            emptyStateLabel.isHidden = false
            stackView.isHidden = true
        } else {
            emptyStateLabel.isHidden = true
            stackView.isHidden = false

            for goal in goals {
                let card = GoalCard(goal: goal)
                card.onTap = { [weak self] in
                    self?.editGoal(goal)
                }
                card.onDelete = { [weak self] in
                    self?.deleteGoal(goal)
                }
                stackView.addArrangedSubview(card)
            }
        }
    }

    @objc private func addGoalTapped() {
        let alert = UIAlertController(title: "New Goal", message: "Enter your goal details", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Goal title"
            textField.accessibilityLabel = "Goal title"
        }

        alert.addTextField { textField in
            textField.placeholder = "Target date (YYYY-MM-DD)"
            textField.accessibilityLabel = "Target date"
            textField.keyboardType = .numbersAndPunctuation
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let title = alert.textFields?[0].text, !title.isEmpty,
                  let dateString = alert.textFields?[1].text else {
                return
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let targetDate = formatter.date(from: dateString) ?? Date().adding(days: 30)

            let goal = Goal(
                title: title,
                targetDate: targetDate,
                progress: 0,
                category: .personal
            )

            self?.goalService.createGoal(goal)
            HapticManager.shared.notification(.success)
            self?.loadGoals()
        }

        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    private func editGoal(_ goal: Goal) {
        let alert = UIAlertController(title: "Edit Goal", message: "Update your goal", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.text = goal.title
            textField.placeholder = "Goal title"
            textField.accessibilityLabel = "Goal title"
        }

        let updateAction = UIAlertAction(title: "Update", style: .default) { [weak self] _ in
            guard let title = alert.textFields?[0].text, !title.isEmpty else {
                return
            }

            var updatedGoal = goal
            updatedGoal.title = title
            self?.goalService.updateGoal(updatedGoal)
            HapticManager.shared.notification(.success)
            self?.loadGoals()
        }

        alert.addAction(updateAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    private func deleteGoal(_ goal: Goal) {
        showConfirmation(
            title: "Delete Goal",
            message: "Are you sure you want to delete \"\(goal.title)\"?",
            confirmTitle: "Delete",
            confirmStyle: .destructive
        ) { [weak self] in
            self?.goalService.deleteGoal(goal.id)
            HapticManager.shared.notification(.success)
            self?.loadGoals()
        }
    }
}

// MARK: - GoalCard

class GoalCard: UIView {

    var onTap: (() -> Void)?
    var onDelete: (() -> Void)?

    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let progressBar = UIProgressView(progressViewStyle: .default)
    private let progressLabel = UILabel()
    private let deleteButton = UIButton(type: .system)

    init(goal: Goal) {
        super.init(frame: .zero)
        setupUI()
        configure(with: goal)
        setupGestures()
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

        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = Theme.Colors.destructive
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        deleteButton.accessibilityLabel = "Delete goal"
        deleteButton.accessibilityHint = "Double tap to delete this goal"

        [titleLabel, dateLabel, progressBar, progressLabel, deleteButton].forEach { addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
            make.trailing.equalTo(deleteButton.snp.leading).offset(-Theme.Spacing.sm)
        }

        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(Theme.Spacing.md)
            make.size.equalTo(32)
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

    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        addGestureRecognizer(tap)
    }

    @objc private func cardTapped() {
        HapticManager.shared.selection()
        onTap?()
    }

    @objc private func deleteTapped() {
        HapticManager.shared.selection()
        onDelete?()
    }
}
