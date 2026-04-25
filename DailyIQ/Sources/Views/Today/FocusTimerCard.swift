import UIKit
import SnapKit

class FocusTimerCard: UIView {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let timerLabel = UILabel()
    private let startButton = UIButton(type: .system)

    private var timer: Timer?
    private var remainingSeconds: Int = 25 * 60
    private var isRunning: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = Theme.Colors.bgSecondary
        layer.cornerRadius = Theme.CornerRadius.card

        titleLabel.text = "Focus Timer"
        titleLabel.font = Theme.Typography.caption()
        titleLabel.textColor = Theme.Colors.txtSecondary

        subtitleLabel.text = "Deep work: Project planning"
        subtitleLabel.font = Theme.Typography.body()
        subtitleLabel.textColor = Theme.Colors.txtPrimary
        subtitleLabel.numberOfLines = 1

        timerLabel.text = "25:00"
        timerLabel.font = .monospacedSystemFont(ofSize: 32, weight: .bold)
        timerLabel.textColor = Theme.Colors.accentPrimary

        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(Theme.Colors.accentPrimary, for: .normal)
        startButton.titleLabel?.font = Theme.Typography.body()
        startButton.addTarget(self, action: #selector(toggleTimer), for: .touchUpInside)

        [titleLabel, subtitleLabel, timerLabel, startButton].forEach { addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.xs)
            make.leading.equalToSuperview().offset(Theme.Spacing.md)
            make.trailing.equalTo(timerLabel.snp.leading).offset(-Theme.Spacing.md)
        }

        timerLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Theme.Spacing.md)
            make.centerY.equalToSuperview()
        }

        startButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().offset(-Theme.Spacing.md)
        }
    }

    @objc private func toggleTimer() {
        if isRunning {
            stopTimer()
            startButton.setTitle("Resume", for: .normal)
        } else {
            startTimer()
            startButton.setTitle("Pause", for: .normal)
        }
        isRunning = !isRunning
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingSeconds -= 1
            if self.remainingSeconds <= 0 {
                self.stopTimer()
                self.resetTimer()
            }
            self.updateTimerLabel()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func resetTimer() {
        remainingSeconds = 25 * 60
        isRunning = false
        startButton.setTitle("Start", for: .normal)
        updateTimerLabel()
    }

    private func updateTimerLabel() {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
}
