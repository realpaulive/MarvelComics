import UIKit

final class AdditionalInfoViewController: UIViewController {
    
    var completion: ((String?, String?) -> ())?
    
    private var viewModel: AdditionalInfoViewModel
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Additional info"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    private lazy var emailTextField: CustomTextFieldView = {
        let tf = CustomTextFieldView(title: "Your e-mail",
                                     placeholder: "example@mail.com",
                                     defaultHintText: "Optional",
                                     type: .regular,
                                     inputValidation: .charValidation(including: viewModel.validCharacterRules.0,
                                                                      excluding: viewModel.validCharacterRules.1))
        tf.validTintColor = viewModel.tintColor
        return tf
        
    }()
    
    private lazy var birthTextField: CustomTextFieldView = {
        let tf = CustomTextFieldView(title: "Your birthday",
                                     placeholder: "01.01.1970",
                                     defaultHintText: "Optional",
                                     type: .regular)
        let datePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(setBday(sender:)), for: .valueChanged)
        tf.textField.inputView = datePicker
        return tf
    }()
    
    private lazy var submitButton: CustomButton = {
        let button = CustomButton(style: .medium,
                                  title: "Submit",
                                  color: .white,
                                  backgroundColor: viewModel.tintColor)
        button.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: AdditionalInfoViewModel) {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstraints()
    }
    
    @objc private func submitTapped() {
        let email = emailTextField.textField.text
        let bday = birthTextField.textField.text
        completion?(email, bday)
    }
    
    @objc private func setBday(sender: UIDatePicker) {
        birthTextField.textField.text = sender.date.description
    }
    
    func bindViewModel() {
        
    }
    
    private func setupViews() {
        view.addSubview(loginLabel)
        view.addSubview(emailTextField)
        view.addSubview(birthTextField)
        view.addSubview(submitButton)
    }
    
    private func setupConstraints() {
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.centerX.equalToSuperview()
            make.height.equalTo(42)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
        
        birthTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(birthTextField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(220)
        }
    }
}
