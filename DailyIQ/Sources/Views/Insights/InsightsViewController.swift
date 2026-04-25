import UIKit
import SnapKit

class InsightsViewController: UIViewController {

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Insights"
        label.font = Theme.Typography.heading1()
        label.textColor = Theme.Colors.txtPrimary
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
        loadInsights()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        // Weekly summary card
        let weeklyCard = createInsightCard(
            title: "Weekly Summary",
            items: [
                ("Tasks Completed", "23"),
                ("Focus Hours", "18.5"),
                ("Productivity Score", "82/100"),
                ("Best Day", "Tuesday"),
            ]
        )

        // Energy patterns card
        let energyCard = createEnergyCard()

        // AI Report card
        let aiReportCard = createAIReportCard()

        [weeklyCard, energyCard, aiReportCard].forEach {
            contentStack.addArrangedSubview($0)
        }
    }

    private func createInsightCard(title: String, items: [(String, String)]) -> UIView {
        let card = UIView()
        card.backgroundColor = Theme.Colors.bgSecondary
        card.layer.cornerRadius = Theme.CornerRadius.card

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Theme.Typography.heading2()
        titleLabel.textColor = Theme.Colors.txtPrimary

        card.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
        }

        let itemsStack = UIStackView()
        itemsStack.axis = .vertical
        itemsStack.spacing = Theme.Spacing.sm

        for (label, value) in items {
            let row = createStatRow(label: label, value: value)
            itemsStack.addArrangedSubview(row)
        }

        card.addSubview(itemsStack)
        itemsStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.bottom.equalToSuperview().inset(Theme.Spacing.md)
        }

        return card
    }

    private func createStatRow(label: String, value: String) -> UIView {
        let row = UIView()

        let labelView = UILabel()
        labelView.text = label
        labelView.font = Theme.Typography.body()
        labelView.textColor = Theme.Colors.txtSecondary

        let valueView = UILabel()
        valueView.text = value
        valueView.font = Theme.Typography.mono()
        valueView.textColor = Theme.Colors.txtPrimary

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

    private func createEnergyCard() -> UIView {
        let card = UIView()
        card.backgroundColor = Theme.Colors.bgSecondary
        card.layer.cornerRadius = Theme.CornerRadius.card

        let titleLabel = UILabel()
        titleLabel.text = "Energy Patterns"
        titleLabel.font = Theme.Typography.heading2()
        titleLabel.textColor = Theme.Colors.txtPrimary

        let insightLabel = UILabel()
        insightLabel.text = "You focus best before noon. Consider scheduling deep work before 12 PM."
        insightLabel.font = Theme.Typography.body()
        insightLabel.textColor = Theme.Colors.txtSecondary
        insightLabel.numberOfLines = 0

        card.addSubview(titleLabel)
        card.addSubview(insightLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
        }

        insightLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.bottom.equalToSuperview().inset(Theme.Spacing.md)
        }

        return card
    }

    private func createAIReportCard() -> UIView {
        let card = UIView()
        card.backgroundColor = Theme.Colors.accentPrimary.withAlphaComponent(0.1)
        card.layer.cornerRadius = Theme.CornerRadius.card
        card.layer.borderWidth = 1
        card.layer.borderColor = Theme.Colors.accentPrimary.cgColor

        let titleLabel = UILabel()
        titleLabel.text = "AI Weekly Report"
        titleLabel.font = Theme.Typography.heading2()
        titleLabel.textColor = Theme.Colors.accentPrimary

        let reportLabel = UILabel()
        reportLabel.text = "This week you completed 23 tasks, 15% above your average. Your productivity peaked on Tuesday with 5 completed tasks. Keep up the momentum!"
        reportLabel.font = Theme.Typography.body()
        reportLabel.textColor = Theme.Colors.txtPrimary
        reportLabel.numberOfLines = 0

        card.addSubview(titleLabel)
        card.addSubview(reportLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(Theme.Spacing.md)
        }

        reportLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Theme.Spacing.sm)
            make.leading.trailing.bottom.equalToSuperview().inset(Theme.Spacing.md)
        }

        return card
    }
}
