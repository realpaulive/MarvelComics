import UIKit

//MARK: - Protocol for delivering data to parent view

protocol TextFieldValidateProtocol: AnyObject {
    func textDidChange(text: String?)
}

final class CustomTextField: UITextField {
    
    //MARK: - Parent view as delegate
    
    weak var delegateView: TextFieldValidateProtocol?
    
    private var type: TextFieldType
    
    //MARK: - Paddding for different types of TextField
    
    private lazy var padding: UIEdgeInsets = {
        switch type {
        case .regular, .email:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        case .password:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 40)
        }
    }()
    
    //MARK: - Button for password type
    
    private var eyeButton = EyeButton()
    
    override init(frame: CGRect) {
        self.type = .regular
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: TextFieldType, placeholder: String) {
        self.init()
        self.type = type
        setupTextField(placeholder: placeholder)
        addTarget(self, action: #selector(sendText), for: .editingChanged)
        switch type {
        case .regular:
            break
        case .email:
            keyboardType = .emailAddress
        case .password:
            rightView = eyeButton
            rightViewMode = .whileEditing
            isSecureTextEntry = true
            keyboardType = .asciiCapable
            eyeButton.addTarget(self, action: #selector(eyeTapped), for: .touchUpInside)
        }
    }
    
    //MARK: - Sending text to parent view
    
    @objc private func sendText() {
        delegateView?.textDidChange(text: text)
    }
    
    @objc private func eyeTapped() {
        isSecureTextEntry.toggle()
        let imageName = isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton.setImage(UIImage(systemName: imageName)?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    //MARK: - Padding implementation
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    private func setupTextField(placeholder: String) {
        self.placeholder = placeholder
        tintColor = .secondaryLabel
        backgroundColor = .secondarySystemBackground
        textColor = .label
        layer.borderWidth = 1
        layer.borderColor = UIColor.tertiarySystemFill.cgColor
        layer.cornerRadius = 12
    }
}

enum TextFieldType {
    case regular
    case email
    case password
}

