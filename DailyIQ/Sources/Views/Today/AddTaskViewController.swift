import UIKit
import SnapKit

class AddTaskViewController: UIViewController {

    var onTaskAdded: (() -> Void)?

    private let titleField = UITextField()
    private let notesField = UITextField()
    private let durationStepper = UIStepper()
    private let durationLabel = UILabel()
    private var selectedPriority: Priority = .p2
    private var selectedCategory: Category = .personal
    private var selectedEnergy: EnergyLevel = .medium

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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

        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        let titleLabel = label("Title")
        titleField.placeholder = "Enter task title"
        titleField.borderStyle = .roundedRect
        titleField.backgroundColor = Theme.Colors.bgSecondary
        titleField.textColor = Theme.Colors.txtPrimary
        titleField.accessibilityLabel = "Task title"
        titleField.accessibilityHint = "Enter the title of your task"

        let notesLabel = label("Notes (optional)")
        notesField.placeholder = "Add notes"
        notesField.borderStyle = .roundedRect
        notesField.backgroundColor = Theme.Colors.bgSecondary
        notesField.textColor = Theme.Colors.txtPrimary
        notesField.accessibilityLabel = "Task notes"
        notesField.accessibilityHint = "Enter optional notes for your task"

        let durationLabelTitle = label("Duration (minutes)")
        durationLabel.text = "30"
        durationLabel.accessibilityLabel = "Duration"
        durationStepper.minimumValue = 5
        durationStepper.maximumValue = 240
        durationStepper.value = 30
        durationStepper.stepValue = 5
        durationStepper.addTarget(self, action: #selector(durationChanged), for: .valueChanged)
        durationStepper.accessibilityLabel = "Task duration stepper"
        durationStepper.accessibilityHint = "Adjust the task duration in 5 minute increments"

        [titleLabel, titleField, notesLabel, notesField, durationLabelTitle, durationLabel, durationStepper].forEach {
            contentView.addSubview($0)
        }

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

        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(durationLabelTitle.snp.bottom).offset(Theme.Spacing.xxl)
        }
    }

    private func label(_ text: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = Theme.Typography.caption()
        lbl.textColor = Theme.Colors.txtSecondary
        return lbl
    }

    @objc private func durationChanged() {
        durationLabel.text = "\(Int(durationStepper.value))"
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func saveTapped() {
        guard let title = titleField.text, !title.isEmpty else {
            return
        }

        // Save task logic here
        onTaskAdded?()
        dismiss(animated: true)
    }
}
