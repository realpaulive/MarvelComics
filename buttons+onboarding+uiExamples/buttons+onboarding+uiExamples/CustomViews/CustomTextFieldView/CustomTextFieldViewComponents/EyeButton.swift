import UIKit

class EyeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        setImage(UIImage(systemName: "eye.slash")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal), for: .normal)
        widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
