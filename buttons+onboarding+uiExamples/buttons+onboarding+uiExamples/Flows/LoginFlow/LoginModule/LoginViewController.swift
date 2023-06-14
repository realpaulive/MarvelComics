import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    
    var registrationHandler: (() -> ())?
    var successAuthHandler: ((String, String) -> ())?
    
    private var viewModel: LoginViewModel
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private lazy var loginTextField: CustomTextFieldView = {
        let tf = CustomTextFieldView(title: "Login",
                                     placeholder: "Your login",
                                     type: .regular)
        tf.textField.addTarget(self, action: #selector(enableButton), for: .editingChanged)
        return tf
        
    }()
    
    private lazy var passwordTextField: CustomTextFieldView = {
        let tf = CustomTextFieldView(title: "Password",
                                     placeholder: "Your password",
                                     type: .password)
        tf.textField.addTarget(self, action: #selector(enableButton), for: .editingChanged)
        return tf
    }()
    
    private lazy var submitButton: CustomButton = {
        let button = CustomButton(style: .medium,
                                  title: "Submit",
                                  color: .white,
                                  backgroundColor: UIColor(red: 221/255, green: 97/255, blue: 64/255, alpha: 1))
        button.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var registrationButton: CustomButton = {
        let button = CustomButton(style: .small, title: "Not registered yet? Sign up!", color: .secondaryLabel)
        button.addTarget(self, action: #selector(registrationTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "status text"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        bindViewModel()
        
        loginTextField.textField.text = User.logins.first?.login
        passwordTextField.textField.text = User.logins.first?.password
        submitButton.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstraints()
    }
    
    @objc private func enableButton() {
        statusLabel.isHidden = true
        guard loginTextField.isValid,
              passwordTextField.isValid else {
            submitButton.isEnabled = false
            return
        }
        submitButton.isEnabled = true
        
    }
    
    @objc private func submitTapped() {
        viewModel.userButtonPressed(login: loginTextField.textField.text ?? "",
                                    password: passwordTextField.textField.text ?? "")
        statusLabel.isHidden = false
    }
    
    @objc private func registrationTapped() {
        registrationHandler?()
    }
    
    func bindViewModel() {
        viewModel.user.bind { user in
            DispatchQueue.main.async {
                self.loginTextField.textField.text = user?.login
                self.passwordTextField.textField.text = user?.password
                self.statusLabel.text = "You succesfully registered"
                self.submitButton.isEnabled = true
            }
        }
        
        viewModel.statusText.bind { statusText in
            DispatchQueue.main.async {
                self.statusLabel.text = statusText
            }
        }
        
        viewModel.statusColor.bind { color in
            DispatchQueue.main.async {
                self.statusLabel.textColor = color
            }
        }
        
        viewModel.isSuccedAuth.bind { isAuth in
            if let login = self.loginTextField.textField.text, let password = self.passwordTextField.textField.text
            { self.successAuthHandler?(login, password) }
            
        }
    }
    
    private func setupViews() {
        view.addSubview(loginLabel)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(submitButton)
        view.addSubview(registrationButton)
        view.addSubview(statusLabel)
        
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
            make.height.equalTo(82)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(82)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(220)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.top.equalTo(submitButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
            make.width.equalTo(220)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(registrationButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
}
