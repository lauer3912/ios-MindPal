import UIKit
import SnapKit

class TaskBlockCard: UIView {

    var onComplete: (() -> Void)?
    var onDefer: (() -> Void)?

    private let taskBlock: TaskBlock

    private let timeLabel = UILabel()
    private let titleLabel = UILabel()
    private let durationBadge = UIView()
    private let categoryIcon = UIImageView()
    private let energyIndicator = UIView()

    init(taskBlock: TaskBlock) {
        self.taskBlock = taskBlock
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = Theme.Colors.bgSecondary
        layer.cornerRadius = Theme.CornerRadius.card

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        timeLabel.text = "\(formatter.string(from: taskBlock.startTime)) - \(formatter.string(from: taskBlock.endTime))"
        timeLabel.font = Theme.Typography.caption()
        timeLabel.textColor = Theme.Colors.txtSecondary

        titleLabel.text = taskBlock.task.title
        titleLabel.font = Theme.Typography.body()
        titleLabel.textColor = Theme.Colors.txtPrimary

        let durationLabel = UILabel()
        durationLabel.text = "\(taskBlock.task.estimatedMinutes) min"
        durationLabel.font = Theme.Typography.caption()
        durationLabel.textColor = Theme.Colors.txtSecondary

        durationBadge.backgroundColor = Theme.Colors.bgTertiary
        durationBadge.layer.cornerRadius = 6
        durationBadge.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
        }

        categoryIcon.image = UIImage(systemName: taskBlock.task.category.iconName)
        categoryIcon.tintColor = Theme.Colors.accentPrimary
        categoryIcon.contentMode = .scaleAspectFit

        energyIndicator.backgroundColor = energyColor(for: taskBlock.task.energyRequired)
        energyIndicator.layer.cornerRadius = 4

        let completeBtn = UIButton(type: .system)
        completeBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        completeBtn.tintColor = Theme.Colors.success
        completeBtn.addTarget(self, action: #selector(completeTapped), for: .touchUpInside)

        let deferBtn = UIButton(type: .system)
        deferBtn.setImage(UIImage(systemName: "clock.arrow.circlepath"), for: .normal)
        deferBtn.tintColor = Theme.Colors.txtSecondary
        deferBtn.addTarget(self, action: #selector(deferTapped), for: .touchUpInside)

        [timeLabel, titleLabel, durationBadge, categoryIcon, energyIndicator, completeBtn, deferBtn].forEach {
            addSubview($0)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
        }

        categoryIcon.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(Theme.Spacing.sm)
            make.leading.equalToSuperview().offset(Theme.Spacing.md)
            make.size.equalTo(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(categoryIcon)
            make.leading.equalTo(categoryIcon.snp.trailing).offset(Theme.Spacing.sm)
            make.trailing.equalTo(completeBtn.snp.leading).offset(-Theme.Spacing.sm)
        }

        durationBadge.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.sm)
            make.leading.equalToSuperview().offset(Theme.Spacing.md)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.md)
        }

        energyIndicator.snp.makeConstraints { make in
            make.leading.equalTo(durationBadge.snp.trailing).offset(Theme.Spacing.sm)
            make.centerY.equalTo(durationBadge)
            make.width.equalTo(4)
            make.height.equalTo(20)
        }

        deferBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Theme.Spacing.md)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }

        completeBtn.snp.makeConstraints { make in
            make.trailing.equalTo(deferBtn.snp.leading).offset(-Theme.Spacing.sm)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }
    }

    private func energyColor(for level: EnergyLevel) -> UIColor {
        switch level {
        case .low: return Theme.Colors.success
        case .medium: return Theme.Colors.accentPrimary
        case .high: return Theme.Colors.warning
        }
    }

    @objc private func completeTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 100, y: 0)
        }) { _ in
            self.onComplete?()
        }
    }

    @objc private func deferTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: -100, y: 0)
        }) { _ in
            self.onDefer?()
        }
    }
}
