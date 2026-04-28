import UIKit
import SnapKit

class InsightsViewController: UIViewController {

    private let insightsService = InsightsService.shared

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Insights"
        label.font = Theme.Typography.heading1()
        label.textColor = Theme.Colors.txtPrimary
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()

    private lazy var contentStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = Theme.Spacing.lg
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        loadInsights()
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.bgPrimary

        [headerLabel, scrollView].forEach { view.addSubview($0) }
        scrollView.addSubview(contentStack)

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Theme.Spacing.lg)
            make.width.equalToSuperview().offset(-Theme.Spacing.lg * 2)
        }
    }

    private func loadInsights() {
        // Clear existing views
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Weekly summary card
        let weeklySummary = insightsService.getWeeklySummary()
        let weeklyCard = createWeeklySummaryCard(summary: weeklySummary)
        contentStack.addArrangedSubview(weeklyCard)

        // Focus stats card
        let focusStats = insightsService.getFocusStats()
        let focusCard = createFocusStatsCard(stats: focusStats)
        contentStack.addArrangedSubview(focusCard)

        // Achievement badges
        let achievements = insightsService.getAchievements()
        let achievementsCard = createAchievementsCard(achievements: achievements)
        contentStack.addArrangedSubview(achievementsCard)

        // AI insights card
        let aiInsights = insightsService.generateAIInsights()
        if !aiInsights.isEmpty {
            let aiCard = createAIInsightsCard(insights: aiInsights)
            contentStack.addArrangedSubview(aiCard)
        }
    }

    // MARK: - Card Creation

    private func createWeeklySummaryCard(summary: InsightsService.WeeklySummary) -> UIView {
        let card = UIView()
        card.backgroundColor = Theme.Colors.bgSecondary
        card.layer.cornerRadius = Theme.CornerRadius.card

        let titleLabel = UILabel()
        titleLabel.text = "Weekly Summary"
        titleLabel.font = Theme.Typography.heading2()
        titleLabel.textColor = Theme.Colors.txtPrimary
        titleLabel.accessibilityTraits = .header
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityLabel = "Weekly Summary"

        let items: [(String, String)] = [
            ("Tasks Completed", "\(summary.tasksCompleted)"),
            ("Focus Hours", String(format: "%.1f", summary.focusHours)),
            ("Productivity Score", "\(summary.productivityScore)/100"),
            ("Best Day", summary.bestDay),
            ("Completion Rate", "\(Int(summary.completionRate * 100))%"),
        ]

        let itemsStack = UIStackView()
        itemsStack.axis = .vertical
        itemsStack.spacing = Theme.Spacing.sm

        for (label, value) in items {
            let row = createStatRow(label: label, value: value)
            itemsStack.addArrangedSubview(row)
        }

        card.addSubview(titleLabel)
        card.addSubview(itemsStack)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
        }

        itemsStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.bottom.equalToSuperview().inset(Theme.Spacing.md)
        }

        return card
    }

    private func createFocusStatsCard(stats: InsightsService.FocusStats) -> UIView {
        let card = UIView()
        card.backgroundColor = Theme.Colors.bgSecondary
        card.layer.cornerRadius = Theme.CornerRadius.card

        let titleLabel = UILabel()
        titleLabel.text = "Focus Statistics"
        titleLabel.font = Theme.Typography.heading2()
        titleLabel.textColor = Theme.Colors.txtPrimary
        titleLabel.accessibilityTraits = .header
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityLabel = "Focus Statistics"

        let items: [(String, String)] = [
            ("Today's Focus", "\(stats.todayMinutes) min"),
            ("Weekly Total", "\(stats.weekMinutes) min"),
            ("Daily Average", "\(Int(stats.avgDailyMinutes)) min"),
            ("Current Streak", "\(stats.streak) days 🔥"),
            ("Peak Hour", "\(stats.peakHour):00"),
        ]

        let itemsStack = UIStackView()
        itemsStack.axis = .vertical
        itemsStack.spacing = Theme.Spacing.sm

        for (label, value) in items {
            let row = createStatRow(label: label, value: value)
            itemsStack.addArrangedSubview(row)
        }

        card.addSubview(titleLabel)
        card.addSubview(itemsStack)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
        }

        itemsStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.bottom.equalToSuperview().inset(Theme.Spacing.md)
        }

        return card
    }

    private func createAchievementsCard(achievements: [InsightsService.Achievement]) -> UIView {
        let card = UIView()
        card.backgroundColor = Theme.Colors.bgSecondary
        card.layer.cornerRadius = Theme.CornerRadius.card

        let titleLabel = UILabel()
        titleLabel.text = "Achievements"
        titleLabel.font = Theme.Typography.heading2()
        titleLabel.textColor = Theme.Colors.txtPrimary
        titleLabel.accessibilityTraits = .header
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityLabel = "Achievements"

        let badgesStack = UIStackView()
        badgesStack.axis = .horizontal
        badgesStack.spacing = Theme.Spacing.md
        badgesStack.distribution = .fillEqually

        for achievement in achievements {
            let badge = createBadgeView(achievement: achievement)
            badgesStack.addArrangedSubview(badge)
        }

        card.addSubview(titleLabel)
        card.addSubview(badgesStack)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
        }

        badgesStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.bottom.equalToSuperview().inset(Theme.Spacing.md)
            make.height.equalTo(80)
        }

        return card
    }

    private func createBadgeView(achievement: InsightsService.Achievement) -> UIView {
        let badge = UIView()
        badge.backgroundColor = achievement.unlocked ? Theme.Colors.accentPrimary.withAlphaComponent(0.2) : Theme.Colors.bgTertiary
        badge.layer.cornerRadius = Theme.CornerRadius.small

        let iconLabel = UILabel()
        iconLabel.text = achievement.iconName == "star.fill" ? "⭐" :
                        achievement.iconName == "flame.fill" ? "🔥" :
                        achievement.iconName == "chart.line.uptrend.xyaxis" ? "📈" : "🧠"
        iconLabel.font = .systemFont(ofSize: 24)
        iconLabel.textAlignment = .center

        let nameLabel = UILabel()
        nameLabel.text = achievement.name
        nameLabel.font = Theme.Typography.caption()
        nameLabel.textColor = achievement.unlocked ? Theme.Colors.txtPrimary : Theme.Colors.txtTertiary
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2

        badge.addSubview(iconLabel)
        badge.addSubview(nameLabel)

        iconLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Theme.Spacing.sm)
            make.centerX.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconLabel.snp.bottom).offset(Theme.Spacing.xs)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.xs)
            make.bottom.lessThanOrEqualToSuperview().offset(-Theme.Spacing.sm)
        }

        badge.isAccessibilityElement = true
        badge.accessibilityLabel = "\(achievement.name): \(achievement.unlocked ? "Unlocked" : "Locked")"
        badge.accessibilityHint = achievement.unlocked ? "Achieved" : "Not yet achieved"

        return badge
    }

    private func createAIInsightsCard(insights: [InsightsService.AIInsight]) -> UIView {
        let card = UIView()
        card.backgroundColor = Theme.Colors.accentPrimary.withAlphaComponent(0.1)
        card.layer.cornerRadius = Theme.CornerRadius.card
        card.layer.borderWidth = 1
        card.layer.borderColor = Theme.Colors.accentPrimary.cgColor

        let titleLabel = UILabel()
        titleLabel.text = "AI Insights"
        titleLabel.font = Theme.Typography.heading2()
        titleLabel.textColor = Theme.Colors.accentPrimary
        titleLabel.accessibilityTraits = .header
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityLabel = "AI Insights"

        let insightsStack = UIStackView()
        insightsStack.axis = .vertical
        insightsStack.spacing = Theme.Spacing.md

        for insight in insights {
            let insightView = createInsightRow(insight: insight)
            insightsStack.addArrangedSubview(insightView)
        }

        card.addSubview(titleLabel)
        card.addSubview(insightsStack)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
        }

        insightsStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.bottom.equalToSuperview().inset(Theme.Spacing.md)
        }

        return card
    }

    private func createInsightRow(insight: InsightsService.AIInsight) -> UIView {
        let row = UIView()

        let iconLabel = UILabel()
        switch insight.type {
        case .productivity: iconLabel.text = "📊"
        case .energy: iconLabel.text = "⚡"
        case .goal: iconLabel.text = "🎯"
        case .suggestion: iconLabel.text = "💡"
        }
        iconLabel.font = .systemFont(ofSize: 20)

        let titleLabel = UILabel()
        titleLabel.text = insight.title
        titleLabel.font = Theme.Typography.body()
        titleLabel.textColor = Theme.Colors.txtPrimary
        titleLabel.accessibilityTraits = .header

        let descLabel = UILabel()
        descLabel.text = insight.description
        descLabel.font = Theme.Typography.caption()
        descLabel.textColor = Theme.Colors.txtSecondary
        descLabel.numberOfLines = 0

        row.addSubview(iconLabel)
        row.addSubview(titleLabel)
        row.addSubview(descLabel)

        iconLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconLabel.snp.trailing).offset(Theme.Spacing.sm)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }

        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconLabel.snp.trailing).offset(Theme.Spacing.sm)
            make.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.xs)
            make.bottom.equalToSuperview()
        }

        row.isAccessibilityElement = true
        row.accessibilityLabel = "\(insight.title): \(insight.description)"

        return row
    }

    private func createStatRow(label: String, value: String) -> UIView {
        let row = UIView()

        let labelView = UILabel()
        labelView.text = label
        labelView.font = Theme.Typography.body()
        labelView.textColor = Theme.Colors.txtSecondary
        labelView.isAccessibilityElement = true
        labelView.accessibilityLabel = "\(label): \(value)"

        let valueView = UILabel()
        valueView.text = value
        valueView.font = Theme.Typography.mono()
        valueView.textColor = Theme.Colors.txtPrimary
        valueView.accessibilityTraits = .updatesFrequently
        valueView.isAccessibilityElement = true
        valueView.accessibilityLabel = "\(label): \(value)"

        row.addSubview(labelView)
        row.addSubview(valueView)

        labelView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }

        valueView.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }

        row.snp.makeConstraints { make in
            make.height.equalTo(32)
        }

        return row
    }
}
