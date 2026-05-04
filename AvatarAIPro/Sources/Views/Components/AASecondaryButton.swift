import UIKit
import SnapKit

final class AASecondaryButton: UIButton {

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
        backgroundColor = .clear
        setTitleColor(.primary, for: .normal)
        setTitleColor(UIColor.primary.withAlphaComponent(0.7), for: .highlighted)
        setTitleColor(UIColor.primary.withAlphaComponent(0.5), for: .disabled)
        titleLabel?.font = .button
        layer.cornerRadius = 28
        layer.borderWidth = 2
        layer.borderColor = UIColor.primary.cgColor

        snp.makeConstraints { make in
            make.height.equalTo(56)
        }

        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    // MARK: - Touch Handling

    @objc private func touchDown() {
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.backgroundColor = UIColor.primary.withAlphaComponent(0.1)
        }
    }

    @objc private func touchUp() {
        UIView.animate(withDuration: 0.15) {
            self.transform = .identity
            self.backgroundColor = .clear
        }
    }
}
