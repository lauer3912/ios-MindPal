import UIKit
import SnapKit

class InsightsViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Insights"
        label.font = Theme.Typography.heading1()
        label.textColor = Theme.Colors.adaptiveTextPrimary
        return label
    }()

    private let weeklyMoodCard: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Colors.adaptiveCardBg
        view.layer.cornerRadius = Theme.CornerRadius.card
        return view
    }()

    private let moodDistributionCard: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Colors.adaptiveCardBg
        view.layer.cornerRadius = Theme.CornerRadius.card
        return view
    }()

    private let aiInsightsCard: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.Colors.accentPrimary.withAlphaComponent(0.1)
        view.layer.cornerRadius = Theme.CornerRadius.card
        view.layer.borderWidth = 1
        view.layer.borderColor = Theme.Colors.accentPrimary.withAlphaComponent(0.3).cgColor
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        populateData()
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.adaptiveBgPrimary
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(weeklyMoodCard)
        contentView.addSubview(moodDistributionCard)
        contentView.addSubview(aiInsightsCard)

        setupWeeklyMoodCard()
        setupMoodDistributionCard()
        setupAIInsightsCard()
    }

    private func setupWeeklyMoodCard() {
        let titleLabel = UILabel()
        titleLabel.text = "Weekly Mood Trend"
        titleLabel.font = Theme.Typography.heading3()
        titleLabel.textColor = Theme.Colors.adaptiveTextPrimary

        let days = ["M", "T", "W", "T", "F", "S", "S"]
        let heights: [CGFloat] = [0.6, 0.4, 0.8, 0.5, 0.9, 0.3, 0.7]
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.accessibilityLabel = "Weekly mood chart"

        for (i, day) in days.enumerated() {
            let bar = UIView()
            bar.backgroundColor = Theme.Colors.accentPrimary.withAlphaComponent(heights[i])
            bar.layer.cornerRadius = 4

            let dayLabel = UILabel()
            dayLabel.text = day
            dayLabel.font = Theme.Typography.caption()
            dayLabel.textColor = Theme.Colors.adaptiveTextSecondary
            dayLabel.textAlignment = .center

            let container = UIView()
            container.addSubview(bar)
            container.addSubview(dayLabel)

            bar.snp.makeConstraints { make in
                make.bottom.equalTo(dayLabel.snp.top).offset(-4)
                make.centerX.equalToSuperview()
                make.width.equalTo(20)
                make.height.equalTo(80 * heights[i])
            }
            dayLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            stackView.addArrangedSubview(container)
        }

        weeklyMoodCard.addSubview(titleLabel)
        weeklyMoodCard.addSubview(stackView)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.md)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.md)
            make.height.equalTo(110)
        }
    }

    private func setupMoodDistributionCard() {
        let titleLabel = UILabel()
        titleLabel.text = "Mood Distribution"
        titleLabel.font = Theme.Typography.heading3()
        titleLabel.textColor = Theme.Colors.adaptiveTextPrimary

        let pieView = UIView()
        pieView.backgroundColor = .clear

        // Simple pie chart representation
        let colors: [UIColor] = [.systemGreen, .systemPurple, .systemBlue, .systemYellow, .systemOrange, .systemRed]
        let percentages: [CGFloat] = [0.35, 0.25, 0.18, 0.12, 0.07, 0.03]
        var startAngle: CGFloat = -.pi / 2

        for (i, pct) in percentages.enumerated() {
            let endAngle = startAngle + pct * 2 * .pi
            // Visual representation with stacked colors
            let label = UILabel()
            label.text = "\(Int(pct * 100))%"
            label.font = Theme.Typography.caption()
            label.textColor = colors[i]
            label.tag = i
            pieView.addSubview(label)
            startAngle = endAngle
        }

        let legendStack = UIStackView()
        legendStack.axis = .horizontal
        legendStack.distribution = .fillEqually
        legendStack.spacing = 4

        let moodLabels = ["Happy", "Calm", "Neutral", "Sad", "Anxious", "Angry"]
        for (i, lbl) in moodLabels.enumerated() {
            let item = UIView()
            let dot = UIView()
            dot.backgroundColor = colors[i]
            dot.layer.cornerRadius = 4
            let label = UILabel()
            label.text = lbl
            label.font = .systemFont(ofSize: 10)
            label.textColor = Theme.Colors.adaptiveTextSecondary
            item.addSubview(dot)
            item.addSubview(label)
            dot.snp.makeConstraints { make in
                make.leading.centerY.equalToSuperview()
                make.size.equalTo(8)
            }
            label.snp.makeConstraints { make in
                make.leading.equalTo(dot.snp.trailing).offset(4)
                make.centerY.equalToSuperview()
            }
            legendStack.addArrangedSubview(item)
        }

        moodDistributionCard.addSubview(titleLabel)
        moodDistributionCard.addSubview(legendStack)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
        }
        legendStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.md)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.md)
        }
    }

    private func setupAIInsightsCard() {
        let iconLabel = UILabel()
        iconLabel.text = "✨"
        iconLabel.font = .systemFont(ofSize: 24)

        let titleLabel = UILabel()
        titleLabel.text = "AI Insight"
        titleLabel.font = Theme.Typography.heading3()
        titleLabel.textColor = Theme.Colors.accentPrimary

        let insightLabel = UILabel()
        insightLabel.text = "You've been feeling more anxious on Monday mornings. Consider starting your week with a brief mindfulness moment."
        insightLabel.font = Theme.Typography.body()
        insightLabel.textColor = Theme.Colors.adaptiveTextPrimary
        insightLabel.numberOfLines = 0

        aiInsightsCard.addSubview(iconLabel)
        aiInsightsCard.addSubview(titleLabel)
        aiInsightsCard.addSubview(insightLabel)

        iconLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconLabel)
            make.leading.equalTo(iconLabel.snp.trailing).offset(Theme.Spacing.sm)
        }
        insightLabel.snp.makeConstraints { make in
            make.top.equalTo(iconLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.md)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.md)
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
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }
        weeklyMoodCard.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }
        moodDistributionCard.snp.makeConstraints { make in
            make.top.equalTo(weeklyMoodCard.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }
        aiInsightsCard.snp.makeConstraints { make in
            make.top.equalTo(moodDistributionCard.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
            make.bottom.equalToSuperview().offset(-Theme.Spacing.xxl)
        }
    }

    private func populateData() {
        // Data is populated in setup methods
    }
}