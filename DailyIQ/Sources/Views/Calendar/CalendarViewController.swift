import UIKit
import SnapKit

class CalendarViewController: UIViewController {

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Calendar"
        label.font = Theme.Typography.heading1()
        label.textColor = Theme.Colors.txtPrimary
        label.accessibilityTraits = .header
        label.isAccessibilityElement = true
        return label
    }()

    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Typography.heading2()
        label.textColor = Theme.Colors.txtPrimary
        label.textAlignment = .center
        label.isAccessibilityElement = true
        return label
    }()

    private lazy var prevButton = UIButton(type: .system)
    private lazy var nextButton = UIButton(type: .system)
    private lazy var weekdayStack: UIStackView = {
        let days = ["S", "M", "T", "W", "T", "F", "S"]
        let labels = days.map { day -> UILabel in
            let l = UILabel()
            l.text = day
            l.font = Theme.Typography.caption()
            l.textColor = Theme.Colors.txtSecondary
            l.textAlignment = .center
            return l
        }
        let stack = UIStackView(arrangedSubviews: labels)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var calendarGrid: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private var currentMonth = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateCalendar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = Theme.Colors.bgPrimary

        prevButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        prevButton.tintColor = Theme.Colors.txtSecondary
        prevButton.addTarget(self, action: #selector(prevMonth), for: .touchUpInside)
        prevButton.accessibilityLabel = "Previous month"
        prevButton.accessibilityHint = "Double tap to see the previous month"
        prevButton.accessibilityTraits = .button

        nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextButton.tintColor = Theme.Colors.txtSecondary
        nextButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        nextButton.accessibilityLabel = "Next month"
        nextButton.accessibilityHint = "Double tap to see the next month"
        nextButton.accessibilityTraits = .button

        [headerLabel, prevButton, monthLabel, nextButton, weekdayStack, calendarGrid].forEach {
            view.addSubview($0)
        }

        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Theme.Spacing.lg)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
        }

        prevButton.snp.makeConstraints { make in
            make.centerY.equalTo(monthLabel)
            make.leading.equalToSuperview().offset(Theme.Spacing.lg)
            make.size.equalTo(44)
        }

        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(Theme.Spacing.lg)
            make.centerX.equalToSuperview()
        }

        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(monthLabel)
            make.trailing.equalToSuperview().offset(-Theme.Spacing.lg)
            make.size.equalTo(44)
        }

        weekdayStack.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.bottom).offset(Theme.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }

        calendarGrid.snp.makeConstraints { make in
            make.top.equalTo(weekdayStack.snp.bottom).offset(Theme.Spacing.md)
            make.leading.trailing.equalToSuperview().inset(Theme.Spacing.lg)
        }
    }

    private func updateCalendar() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        monthLabel.text = formatter.string(from: currentMonth)

        calendarGrid.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        guard let firstDay = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDay) else { return }

        let firstWeekday = calendar.component(.weekday, from: firstDay)

        var day = 1
        var weekRows: [[Int?]] = Array(repeating: Array(repeating: nil, count: 7), count: 6)

        var row = 0
        var col = firstWeekday - 1

        for _ in 0..<range.count {
            weekRows[row][col] = day
            day += 1
            col += 1
            if col > 6 {
                col = 0
                row += 1
            }
        }

        for weekRow in weekRows {
            let weekStack = UIStackView()
            weekStack.axis = .horizontal
            weekStack.distribution = .fillEqually
            weekStack.spacing = 8

            for dayValue in weekRow {
                let dayLabel = UILabel()
                dayLabel.text = dayValue.map { String($0) }
                dayLabel.font = Theme.Typography.body()
                dayLabel.textAlignment = .center

                if let val = dayValue {
                    let isToday = val == calendar.component(.day, from: Date()) &&
                                  calendar.isDate(currentMonth, equalTo: Date(), toGranularity: .month)
                    dayLabel.textColor = isToday ? Theme.Colors.accentPrimary : Theme.Colors.txtPrimary
                    dayLabel.accessibilityLabel = "\(val)"
                    dayLabel.accessibilityTraits = isToday ? .button : .staticText
                    dayLabel.isAccessibilityElement = true
                } else {
                    dayLabel.text = ""
                    dayLabel.isAccessibilityElement = false
                }

                weekStack.addArrangedSubview(dayLabel)
            }

            calendarGrid.addArrangedSubview(weekStack)
        }
    }

    @objc private func prevMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
        updateCalendar()
    }

    @objc private func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
        updateCalendar()
    }
}
