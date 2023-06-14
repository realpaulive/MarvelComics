import UIKit
import SnapKit

final class EnterPhoneViewController: UIViewController {
    
    var completion: ((String, String?) -> ())?
    
    private var viewModel: EnterPhoneViewModel
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Add your phone"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private lazy var phoneTextField: CustomTextFieldView = {
        let tf = CustomTextFieldView(title: "Current phone",
                                     placeholder: "+7 (999) 999-99-99",
                                     defaultHintText: "Required",
                                     type: .regular,
                                     inputValidation: .charCapacity(min: viewModel.validCapacityRules.0,
                                                                    max: viewModel.validCapacityRules.1,
                                                                    recommend: nil))
        tf.textField.keyboardType = .numberPad
        tf.validTintColor = viewModel.tintColor
        tf.textField.addTarget(self, action: #selector(enableButton), for: .editingChanged)
        return tf
        
    }()
    
    private lazy var nameTextField: CustomTextFieldView = {
        let tf = CustomTextFieldView(title: "Your name",
                                     placeholder: "John Smith",
                                     defaultHintText: "Optional",
                                     type: .regular)
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
    
    init(viewModel: EnterPhoneViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = viewModel.tintColor
        setupViews()
        bindViewModel()
        nextButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstraints()
    }
    
    @objc private func enableButton() {
        guard phoneTextField.isValid else {
            nextButton.isEnabled = false
            return
        }
        nextButton.isEnabled = true
        
    }
    
    @objc private func nextTapped() {
        guard let phone = phoneTextField.textField.text else { return }
        let name = nameTextField.textField.text
        completion?(phone, name)
    }
    
    func bindViewModel() {
        
    }
    
    private func setupViews() {
        view.addSubview(loginLabel)
        view.addSubview(phoneTextField)
        view.addSubview(nameTextField)
        view.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.centerX.equalToSuperview()
            make.height.equalTo(42)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(220)
        }
    }
}

