import UIKit
import SnapKit

class CustomTextFieldView: UIView {
    
    var textField: CustomTextField
    
    private var defaultHintText: String?
    
    var invalidTintColor = UIColor.red
    var mayValidTintColor = UIColor.orange
    var validTintColor = UIColor.green
    var defaultTintColor = UIColor.tertiarySystemFill
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var hintTextLabel: UILabel = {
        let label = UILabel()
        label.text = defaultHintText
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .tertiaryLabel
        return label
    }()
    
    lazy private var infoImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "info.circle.fill")
        imageView.image = image?.withTintColor(.tertiaryLabel, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    override init(frame: CGRect) {
        self.textField = CustomTextField(type: .regular, placeholder: "Placeholder")
        self.inputValidation = .noValidation
        super.init(frame: frame)
    }
    
    convenience init(title: String,
                     placeholder: String,
                     defaultHintText: String? = nil,
                     type: TextFieldType,
                     inputValidation: InputValidation = .noValidation) {
        self.init()
        self.clipsToBounds = true
        self.textField = CustomTextField(type: type, placeholder: placeholder)
        self.titleLabel.text = title
        self.inputValidation = inputValidation
        self.defaultHintText = defaultHintText ?? "Hint text"
        
        switch inputValidation {
        case .charValidation, .charCapacity:
            break
        case .noValidation:
            self.hintTextLabel.isHidden = true
            self.infoImage.isHidden = true
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        textField.delegateView = self
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(hintTextLabel)
        addSubview(infoImage)
        addSubview(textField)
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(48)
        }
        
        infoImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(hintTextLabel)
            make.width.height.equalTo(16)
        }
        
        hintTextLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(16)
            make.left.equalTo(infoImage.snp.right).offset(8)
            make.right.equalTo(titleLabel)
        }
    }
    
    //MARK: - Validation type
    
    private var inputValidation: InputValidation
    
    //MARK: - States for different validation results
    
    private var validationState: ValidationState = .valid {
        didSet {
            switch validationState {
            case .valid:
                textField.layer.borderColor = validTintColor.cgColor
                infoImage.image = UIImage(systemName: "checkmark.circle.fill")!.withTintColor(validTintColor, renderingMode: .alwaysOriginal)
                hintTextLabel.textColor = validTintColor
                hintTextLabel.text = "Everything is fine"
                isValid = true
            case .mayValid:
                textField.layer.borderColor = mayValidTintColor.cgColor
                infoImage.image = UIImage(systemName: "checkmark.circle.fill")!.withTintColor(mayValidTintColor, renderingMode: .alwaysOriginal)
                hintTextLabel.textColor = mayValidTintColor
                isValid = true
                return
            case .invalid:
                textField.layer.borderColor = invalidTintColor.cgColor
                infoImage.image = UIImage(systemName: "xmark.circle.fill")!.withTintColor(invalidTintColor, renderingMode: .alwaysOriginal)
                hintTextLabel.textColor = invalidTintColor
                isValid = false
                return
            }
        }
    }
    
    //MARK: - Value for future using (to enable some buttons for example)
    
    var isValid = false  // Default value
    
}


//MARK: - Validation logic (it's difficult, but works)

extension CustomTextFieldView: TextFieldValidateProtocol {
    func textDidChange(text: String?) {
        guard let text = text else {
            isValid = false
            hintTextLabel.text = defaultHintText
            hintTextLabel.textColor = defaultTintColor
            infoImage.tintColor = defaultTintColor
            return
        }
        
        switch inputValidation {
            
            //MARK: - Validation whith some characters
            
        case .charValidation(including: let including, excluding: let excluding):
            
            if let includingChar = including {
                if text.lowercased().rangeOfCharacter(from: includingChar) == nil
                {
                    validationState = .invalid
                    hintTextLabel.text = "Check your input again"
                    return
                }
            } else {
                validationState = .valid
            }
            
            
            if let includingChar = including, let excludingChar = excluding {
                if text.lowercased().rangeOfCharacter(from: includingChar) != nil
                    && text.lowercased().rangeOfCharacter(from: excludingChar) == nil
                {
                    validationState = .valid
                    return
                }
            } else if let excludingChar = excluding {
                if text.lowercased().rangeOfCharacter(from: excludingChar) != nil
                {
                    validationState = .invalid
                    hintTextLabel.text = "Unacceptable symbols"
                    return
                }
            } else if text == "" {
                validationState = .invalid
            } else {
                validationState = .valid
            }
            
            
            //MARK: - Validation whith capacity
            
        case .charCapacity(min: let min, max: let max, recommend: let recommend):
            
            if let minCharCount = min {
                if text.count <= minCharCount {
                    validationState = .invalid
                    hintTextLabel.text = "Not enough symbols"
                    return
                }
            } else {
                validationState = .valid
            }
            
            if let recommendCharCount = recommend {
                if text.count <= recommendCharCount { textField.layer.borderColor = UIColor.orange.cgColor
                    validationState = .mayValid
                    hintTextLabel.text = "Recommend adding more symbols"
                    return
                }
            } else {
                validationState = .valid
            }
            
            if let recommedCahrCount = recommend, let maxCharCount = max {
                if text.count >= recommedCahrCount && text.count < maxCharCount { textField.layer.borderColor = UIColor.red.cgColor
                    validationState = .valid
                }
            }
            
            if let maxCharCount = max {
                if text.count > maxCharCount { textField.layer.borderColor = UIColor.red.cgColor
                    validationState = .invalid
                    hintTextLabel.text = "Too many symbols"
                }
            } else {
                validationState = .valid
            }
            
            //MARK: - Default
            
        case .noValidation:
            if text == "" { isValid = false }
            else { isValid = true }
            return
        }
    }
}




extension CustomTextFieldView {
    
    //MARK: - Validation types
    
    enum InputValidation {
        case charValidation(including: CharacterSet?, excluding: CharacterSet?)
        case charCapacity(min: Int?, max: Int?, recommend: Int?)
        case noValidation
    }
    
    //MARK: - States
    
    enum ValidationState {
        case valid
        case mayValid
        case invalid
    }
}
