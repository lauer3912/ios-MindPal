import UIKit
import SnapKit

class EnergyRingView: UIView {

    private let ringLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    private let percentLabel = UILabel()
    private let titleLabel = UILabel()

    private var currentEnergy: Int = 70

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        // Track layer (background ring)
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = Theme.Colors.bgTertiary.cgColor
        trackLayer.lineWidth = 12
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)

        // Ring layer (progress)
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeColor = Theme.Colors.accentPrimary.cgColor
        ringLayer.lineWidth = 12
        ringLayer.lineCap = .round
        ringLayer.strokeEnd = 0.75
        layer.addSublayer(ringLayer)

        percentLabel.text = "75%"
        percentLabel.font = .monospacedSystemFont(ofSize: 36, weight: .bold)
        percentLabel.textColor = Theme.Colors.txtPrimary
        percentLabel.textAlignment = .center

        titleLabel.text = "Energy Level"
        titleLabel.font = Theme.Typography.caption()
        titleLabel.textColor = Theme.Colors.txtSecondary
        titleLabel.textAlignment = .center

        addSubview(percentLabel)
        addSubview(titleLabel)

        percentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(percentLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 12

        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: .pi * 1.5,
            clockwise: true
        )

        trackLayer.path = path.cgPath
        ringLayer.path = path.cgPath
    }

    func setEnergyLevel(_ level: Int) {
        currentEnergy = min(100, max(0, level))
        percentLabel.text = "\(currentEnergy)%"

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = ringLayer.strokeEnd
        animation.toValue = CGFloat(currentEnergy) / 100.0
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        ringLayer.strokeEnd = CGFloat(currentEnergy) / 100.0
        ringLayer.add(animation, forKey: "strokeEnd")

        // Change color based on energy level
        if currentEnergy >= 70 {
            ringLayer.strokeColor = Theme.Colors.success.cgColor
        } else if currentEnergy >= 40 {
            ringLayer.strokeColor = Theme.Colors.accentPrimary.cgColor
        } else {
            ringLayer.strokeColor = Theme.Colors.warning.cgColor
        }
    }
}
