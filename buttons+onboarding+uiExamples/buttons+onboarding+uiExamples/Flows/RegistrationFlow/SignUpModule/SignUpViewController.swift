import UIKit
import SnapKit

final class SignUpViewController: UIViewController {
    
    var completion: ((String, String)->())?
    var backHandler: (()->())?
    
    private var viewModel: SignUpViewModel
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign up"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private lazy var loginTextField: CustomTextFieldView = {
        let tf = CustomTextFieldView(title: "Create login",
                                     placeholder: "Your login",
                                     defaultHintText: "Should be unique",
                                     type: .regular,
                                     inputValidation: .charValidation(including: nil,
                                                                      excluding: viewModel.excludeCharacters))
        tf.validTintColor = viewModel.tintColor
        tf.textField.addTarget(self, action: #selector(enableButton), for: .editingChanged)
        return tf
        
    }()
    
    private lazy var passwordTextField: CustomTextFieldView = {
        let tf = CustomTextFieldView(title: "Create password",
                                     placeholder: "Your password",
                                     defaultHintText: "Minimum length - \(viewModel.validCapacityRules.0) characters",
                                     type: .password,
                                     inputValidation: .charCapacity(min: viewModel.validCapacityRules.0,
                                                                    max: viewModel.validCapacityRules.1,
                                                                    recommend: viewModel.validCapacityRules.2))
        tf.validTintColor = viewModel.tintColor
        tf.textField.addTarget(self, action: #selector(enableButton), for: .editingChanged)
        return tf
    }()
    
    private lazy var nextButton: CustomButton = {
        let button = CustomButton(style: .medium,
                                  title: "Next",
                                  color: .white,
                                  backgroundColor: viewModel.tintColor)
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        backHandler?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = viewModel.tintColor
        setupViews()
        nextButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstraints()
    }
    
    @objc private func enableButton() {
        guard loginTextField.isValid,
              passwordTextField.isValid else {
            nextButton.isEnabled = false
            return
        }
        nextButton.isEnabled = true
        
    }
    
    @objc private func nextTapped() {
        guard let login = loginTextField.textField.text,
              let password = passwordTextField.textField.text else { return }
        completion?(login, password)
    }
    
    private func setupViews() {
        view.addSubview(loginLabel)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.centerX.equalToSuperview()
            make.height.equalTo(42)
        }
        
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(220)
        }
    }
}
