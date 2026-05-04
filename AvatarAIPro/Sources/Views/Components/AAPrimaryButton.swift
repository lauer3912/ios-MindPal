import UIKit
import SnapKit

final class AAPrimaryButton: UIButton {

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    convenience init(title: String) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
    }

    // MARK: - Setup

    private func setupButton() {
        backgroundColor = .primary
        setTitleColor(.white, for: .normal)
        setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .highlighted)
        setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        titleLabel?.font = .button
        layer.cornerRadius = 28
        clipsToBounds = true

        // Add gradient layer
        applyGradient()

        snp.makeConstraints { make in
            make.height.equalTo(56)
        }

        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    // MARK: - Private Methods

    private func applyGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = UIColor.primaryGradient
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 28
        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let gradientLayer = layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = bounds
        }
    }

    // MARK: - Touch Handling

    @objc private func touchDown() {
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.9
        }
    }

    @objc private func touchUp() {
        UIView.animate(withDuration: 0.15) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}
