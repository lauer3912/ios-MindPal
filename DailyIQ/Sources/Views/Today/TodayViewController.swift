import UIKit
import SnapKit

class TodayViewController: UIViewController {

    // MARK: - UI Components

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.alwaysBounceVertical = true
        return sv
    }()

    private lazy var contentView = UIView()

    private lazy var headerView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Typography.heading1()
        label.textColor = Theme.Colors.txtPrimary
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()

    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Typography.body()
        label.textColor = Theme.Colors.txtSecondary
        label.isAccessibilityElement = true
        return label
    }()

    private lazy var energyRingView: EnergyRingView = {
        let view = EnergyRingView()
        view.isAccessibilityElement = true
        view.accessibilityLabel = "Energy ring"
        view.accessibilityHint = "Shows your current energy level"
        return view
    }()

    private lazy var focusTimerCard: FocusTimerCard = {
        let card = FocusTimerCard()
        return card
    }()

    private lazy var taskSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Today's Schedule"
        label.font = Theme.Typography.heading2()
        label.textColor = Theme.Colors.txtPrimary
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()

    private lazy var taskStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = Theme.Spacing.md
        return sv
    }()

    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        btn.tintColor = Theme.Colors.accentPrimary
        btn.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        btn.accessibilityLabel = "Add new task"
        btn.accessibilityHint = "Double tap to add a new task"
        btn.accessibilityTraits = .button
        return btn
    }()

    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No tasks for today.\nTap + to add your first task."
        label.font = Theme.Typography.body()
        label.textColor = Theme.Colors.txtSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.accessibilityLabel = "No tasks scheduled. Tap the add button to create your first task."
        label.accessibilityTraits = .staticText
        return label
    }()

    private let viewModel = TodayViewModel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = Theme.Colors.bgPrimary

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        [dateLabel, dayLabel, addButton].forEach { headerView.addSubview($0) }
        [headerView, energyRingView, focusTimerCard, taskSectionLabel, taskStackView, emptyStateLabel].forEach {
            contentView.addSubview($0)
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

        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(60)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Theme.Spacing.xs)
            make.leading.equalToSuperview()
        }

        addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(44)
        }

        energyRingView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(Theme.Spacing.lg)
            make.centerX.equalToSuperview()
            make.size.equalTo(180)
        }

        focusTimerCard.snp.makeConstraints { make in
            make.top.equalTo(energyRingView.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(100)
        }

        taskSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(focusTimerCard.snp.bottom).offset(Theme.Spacing.xl)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        taskStackView.snp.makeConstraints { make in
            make.top.equalTo(taskSectionLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.xxl)
        }

        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalTo(taskStackView)
        }
    }

    // MARK: - Data

    private func loadData() {
        updateDateHeader()
        viewModel.generateDailySchedule()
        updateUI()
    }

    private func updateDateHeader() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        dateLabel.text = formatter.string(from: Date())

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        dayLabel.text = dayFormatter.string(from: Date())
    }

    private func updateUI() {
        let schedule = viewModel.dailySchedule

        energyRingView.setEnergyLevel(schedule.energyLevel)

        taskStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if schedule.taskBlocks.isEmpty {
            emptyStateLabel.isHidden = false
            taskStackView.isHidden = true
        } else {
            emptyStateLabel.isHidden = true
            taskStackView.isHidden = false

            for block in schedule.taskBlocks {
                let card = TaskBlockCard(taskBlock: block)
                card.onComplete = { [weak self] in
                    self?.viewModel.completeTask(block.id)
                    self?.updateUI()
                }
                card.onDefer = { [weak self] in
                    self?.viewModel.deferTask(block.id)
                    self?.updateUI()
                }
                taskStackView.addArrangedSubview(card)
            }
        }
    }

    // MARK: - Actions

    @objc private func addTaskTapped() {
        let addVC = AddTaskViewController()
        addVC.onTaskAdded = { [weak self] in
            self?.loadData()
        }
        let nav = UINavigationController(rootViewController: addVC)
        present(nav, animated: true)
    }
}
