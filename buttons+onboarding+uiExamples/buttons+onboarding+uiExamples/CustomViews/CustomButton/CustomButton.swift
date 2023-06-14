import UIKit

final class CustomButton: UIButton {
    
    private var bgColor: UIColor?
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? bgColor?.withAlphaComponent(0.9) : bgColor
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? bgColor : .systemGray 
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton(title: "Button")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton(title: "Button")
    }
    
    convenience init(style: ButtonType,
                     title: String,
                     image: UIImage? = nil,
                     imageAlignment: ImageAlignment = .left,
                     color: UIColor = .blue,
                     backgroundColor: UIColor? = nil,
                     whithShadows: Bool = false) {
        
        self.init()
        self.bgColor = backgroundColor
        
        switch style {
        case .large:
            setupButton(title: title,
                        image: image?.applyingSymbolConfiguration(.init(scale: .large)),
                        imageAlignment: imageAlignment,
                        font: .systemFont(ofSize: 21, weight: .semibold),
                        color: color,
                        bgColor: backgroundColor,
                        imageInset: 18,
                        contentInset: .init(top: 12, left: 24, bottom: 12, right: 24)
            )
        case .medium:
            setupButton(title: title,
                        image: image?.applyingSymbolConfiguration(.init(scale: .default)),
                        imageAlignment: imageAlignment,
                        font: .systemFont(ofSize: 16, weight: .medium),
                        color: color,
                        bgColor: backgroundColor,
                        imageInset: 12,
                        contentInset: .init(top: 8, left: 16, bottom: 8, right: 16)
            )
        case .small:
            setupButton(title: title,
                        image: image?.applyingSymbolConfiguration(.init(scale: .small)),
                        imageAlignment: imageAlignment,
                        font: .systemFont(ofSize: 10, weight: .semibold),
                        color: color,
                        bgColor: backgroundColor,
                        imageInset: 6,
                        contentInset: .init(top: 4, left: 8, bottom: 4, right: 8)
            )
        }
        if whithShadows { setShadow() }
    }
    
    //MARK: - Seting various states for button
    
    private func setupButton(title: String,
                             image: UIImage? = nil,
                             imageAlignment: ImageAlignment = .left,
                             font: UIFont = .systemFont(ofSize: 16, weight: .regular),
                             color: UIColor = .label,
                             bgColor: UIColor? = nil,
                             imageInset: CGFloat = 16,
                             contentInset: UIEdgeInsets = .init(top: 8, left: 16, bottom: 8, right: 16)
    ) {
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        setTitleColor(color.withAlphaComponent(0.9), for: .highlighted)
        setTitleColor(color.withAlphaComponent(0.7), for: .disabled)
        
        setImage(image?.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        setImage(image?.withTintColor(color.withAlphaComponent(0.9), renderingMode: .alwaysOriginal), for: .highlighted)
        setImage(image?.withTintColor(color.withAlphaComponent(0.7), renderingMode: .alwaysOriginal), for: .disabled)
        
        imageView?.contentMode = .scaleAspectFit
                
        titleLabel?.font = font
        contentEdgeInsets = contentInset
        
        switch imageAlignment {
        case .left:
            semanticContentAttribute = .forceLeftToRight
            imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: imageInset)
        case .right:
            semanticContentAttribute = .forceRightToLeft
            imageEdgeInsets = .init(top: 0, left: imageInset, bottom: 0, right: 0)
        }
        
        layer.cornerRadius = 12
        backgroundColor = bgColor
    }
    
    private func setShadow() {
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOffset = .init(width: 0, height: 4)
        layer.shadowOpacity = 0.1
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    private func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        UIGraphicsEndImageContext()
        
    }
    
}

extension CustomButton {
    enum ButtonType {
        case large
        case medium
        case small
    }
    
    enum ImageAlignment {
        case left
        case right
    }
}
