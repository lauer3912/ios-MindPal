import UIKit
import SnapKit

class AddTaskViewController: UIViewController {

    var onTaskAdded: (() -> Void)?

    private let taskService = TaskService.shared
    private let notificationService = NotificationService.shared

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleField = UITextField()
    private let notesField = UITextField()
    private let durationStepper = UIStepper()
    private let durationLabel = UILabel()
    private var selectedPriority: Priority = .p2
    private var selectedCategory: Category = .personal
    private var selectedEnergy: EnergyLevel = .medium
    private var selectedDueDate: Date?

    // Priority segment control
    private lazy var prioritySegment: UISegmentedControl = {
        let items = Priority.allCases.map { $0.displayName }
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 2 // P2 default
        segment.addTarget(self, action: #selector(priorityChanged), for: .valueChanged)
        return segment
    }()

    // Category picker
    private lazy var categoryPicker: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Personal", for: .normal)
        btn.setImage(UIImage(systemName: "person.fill"), for: .normal)
        btn.tintColor = Theme.Colors.accentPrimary
        btn.backgroundColor = Theme.Colors.bgSecondary
        btn.layer.cornerRadius = Theme.CornerRadius.button
        btn.showsMenuAsPrimaryAction = true
        btn.menu = createCategoryMenu()
        return btn
    }()

    // Energy picker
    private lazy var energyPicker: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Medium Energy", for: .normal)
        btn.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
        btn.tintColor = Theme.Colors.accentPrimary
        btn.backgroundColor = Theme.Colors.bgSecondary
        btn.layer.cornerRadius = Theme.CornerRadius.button
        btn.showsMenuAsPrimaryAction = true
        btn.menu = createEnergyMenu()
        return btn
    }()

    // Due date picker
    private lazy var dueDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.minimumDate = Date()
        picker.maximumDate = Date().adding(days: 365)
        picker.addTarget(self, action: #selector(dueDateChanged), for: .valueChanged)
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismissal()
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.bgPrimary
        title = "Add Task"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveTapped)
        )

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        // Title section
        let titleLabel = createLabel("Title")
        titleField.placeholder = "Enter task title"
        titleField.borderStyle = .roundedRect
        titleField.backgroundColor = Theme.Colors.bgSecondary
        titleField.textColor = Theme.Colors.txtPrimary
        titleField.accessibilityLabel = "Task title"
        titleField.accessibilityHint = "Enter the title of your task"

        // Notes section
        let notesLabel = createLabel("Notes (optional)")
        notesField.placeholder = "Add notes"
        notesField.borderStyle = .roundedRect
        notesField.backgroundColor = Theme.Colors.bgSecondary
        notesField.textColor = Theme.Colors.txtPrimary
        notesField.accessibilityLabel = "Task notes"
        notesField.accessibilityHint = "Enter optional notes for your task"

        // Duration section
        let durationLabelTitle = createLabel("Duration (minutes)")
        durationLabel.text = "30"
        durationLabel.font = Theme.Typography.mono()
        durationLabel.textColor = Theme.Colors.txtPrimary
        durationLabel.accessibilityLabel = "Duration"
        durationStepper.minimumValue = 5
        durationStepper.maximumValue = 240
        durationStepper.value = 30
        durationStepper.stepValue = 5
        durationStepper.addTarget(self, action: #selector(durationChanged), for: .valueChanged)
        durationStepper.accessibilityLabel = "Task duration stepper"
        durationStepper.accessibilityHint = "Adjust the task duration in 5 minute increments"

        // Priority section
        let priorityLabel = createLabel("Priority")
        prioritySegment.accessibilityLabel = "Task priority selector"

        // Category section
        let categoryLabel = createLabel("Category")
        categoryLabel.accessibilityLabel = "Task category"

        // Energy section
        let energyLabel = createLabel("Energy Required")
        energyLabel.accessibilityLabel = "Energy required level"

        // Due date section
        let dueDateLabel = createLabel("Due Date (optional)")
        dueDateLabel.accessibilityLabel = "Task due date"

        // Add all subviews
        [titleLabel, titleField, notesLabel, notesField,
         durationLabelTitle, durationLabel, durationStepper,
         priorityLabel, prioritySegment,
         categoryLabel, categoryPicker,
         energyLabel, energyPicker,
         dueDateLabel, dueDatePicker].forEach {
            contentView.addSubview($0)
        }

        // Layout
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }
        titleField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.sm)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(44)
        }

        notesLabel.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }
        notesField.snp.makeConstraints { make in
            make.top.equalTo(notesLabel.snp.bottom).offset(Theme.Spacing.sm)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(80)
        }

        durationLabelTitle.snp.makeConstraints { make in
            make.top.equalTo(notesField.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }
        durationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(durationLabelTitle)
            make.leading.equalTo(durationLabelTitle.snp.trailing).offset(Theme.Spacing.md)
        }
        durationStepper.snp.makeConstraints { make in
            make.centerY.equalTo(durationLabelTitle)
            make.trailing.equalToSuperview().offset(-Theme.Spacing.lg)
        }

        priorityLabel.snp.makeConstraints { make in
            make.top.equalTo(durationLabelTitle.snp.bottom).offset(Theme.Spacing.xl)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }
        prioritySegment.snp.makeConstraints { make in
            make.top.equalTo(priorityLabel.snp.bottom).offset(Theme.Spacing.sm)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }

        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(prioritySegment.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }
        categoryPicker.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(Theme.Spacing.sm)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(44)
        }

        energyLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryPicker.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }
        energyPicker.snp.makeConstraints { make in
            make.top.equalTo(energyLabel.snp.bottom).offset(Theme.Spacing.sm)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.height.equalTo(44)
        }

        dueDateLabel.snp.makeConstraints { make in
            make.top.equalTo(energyPicker.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }
        dueDatePicker.snp.makeConstraints { make in
            make.top.equalTo(dueDateLabel.snp.bottom).offset(Theme.Spacing.sm)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(dueDatePicker.snp.bottom).offset(Theme.Spacing.xxl)
        }
    }

    private func createLabel(_ text: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = Theme.Typography.caption()
        lbl.textColor = Theme.Colors.txtSecondary
        lbl.isAccessibilityElement = true
        return lbl
    }

    private func setupKeyboardDismissal() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func createCategoryMenu() -> UIMenu {
        let actions = Category.allCases.map { category in
            UIAction(
                title: category.displayName,
                image: UIImage(systemName: category.iconName)
            ) { [weak self] _ in
                self?.selectedCategory = category
                self?.categoryPicker.setTitle(category.displayName, for: .normal)
                self?.categoryPicker.setImage(UIImage(systemName: category.iconName), for: .normal)
                HapticManager.shared.selection()
            }
        }
        return UIMenu(title: "Category", children: actions)
    }

    private func createEnergyMenu() -> UIMenu {
        let actions = EnergyLevel.allCases.map { level in
            let icon: String
            switch level {
            case .low: icon = "battery.25"
            case .medium: icon = "battery.50"
            case .high: icon = "battery.100"
            }

            UIAction(
                title: level.displayName,
                image: UIImage(systemName: icon)
            ) { [weak self] _ in
                self?.selectedEnergy = level
                self?.energyPicker.setTitle(level.displayName, for: .normal)
                self?.energyPicker.setImage(UIImage(systemName: icon), for: .normal)
                HapticManager.shared.selection()
            }
        }
        return UIMenu(title: "Energy Required", children: actions)
    }

    @objc private func durationChanged() {
        durationLabel.text = "\(Int(durationStepper.value))"
        HapticManager.shared.selection()
    }

    @objc private func priorityChanged() {
        selectedPriority = Priority(rawValue: prioritySegment.selectedSegmentIndex) ?? .p2
        HapticManager.shared.selection()
    }

    @objc private func dueDateChanged() {
        selectedDueDate = dueDatePicker.date
        HapticManager.shared.selection()
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func saveTapped() {
        guard let title = titleField.text, !title.isEmpty else {
            showAlert(title: "Error", message: "Please enter a task title")
            return
        }

        let task = Task(
            title: title,
            notes: notesField.text,
            estimatedMinutes: Int(durationStepper.value),
            priority: selectedPriority,
            category: selectedCategory,
            energyRequired: selectedEnergy,
            dueDate: selectedDueDate,
            recurring: nil,
            status: .pending
        )

        // Save to database
        taskService.createTask(task)

        // Schedule notification if due date is set
        if let dueDate = selectedDueDate {
            notificationService.scheduleTaskNotification(for: task, at: dueDate)
        }

        // Trigger haptic feedback
        HapticManager.shared.notification(.success)

        // Notify parent and dismiss
        onTaskAdded?()
        dismiss(animated: true)
    }
}
