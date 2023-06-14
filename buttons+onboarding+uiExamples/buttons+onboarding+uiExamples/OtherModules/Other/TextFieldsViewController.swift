import UIKit
import SnapKit

final class TextFieldsViewController: UIViewController {
    
    //MARK: - Test values
    
    private var minCharCount: Int = 4
    private var maxCharCount: Int = 18
    private var recommendCharCount: Int = 8
    private var includingChar: CharacterSet = ["@"]
    private var excludingChar: CharacterSet = .init(charactersIn: ";<>]+=?&,:'` ")
    
    
    //MARK: - Creating textfields
    
    lazy private var ctf1 = CustomTextFieldView(title: "Your name",
                                                placeholder: "Name",
                                                type: .regular,
                                                inputValidation: .noValidation)
    
    lazy private var ctf2 = CustomTextFieldView(title: "Your e-mail",
                                                placeholder: "E-mail",
                                                type: .email,
                                                inputValidation: .charValidation(including: includingChar,
                                                                                 excluding: excludingChar))
    
    lazy private var ctf3 = CustomTextFieldView(title: "Your password",
                                                placeholder: "Password",
                                                type: .password,
                                                inputValidation: .charCapacity(min: minCharCount,
                                                                               max: maxCharCount,
                                                                               recommend: recommendCharCount))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSuperView()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstraints()
    }
    
    private func prepareSuperView() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "TextField"
    }
    
    private func setupViews() {
        view.addSubview(ctf1)
        view.addSubview(ctf2)
        view.addSubview(ctf3)
    }
    
    private func setupConstraints() {
        
        ctf1.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
        
        ctf2.snp.makeConstraints { make in
            make.top.equalTo(ctf1.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
        
        ctf3.snp.makeConstraints { make in
            make.top.equalTo(ctf2.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
    }
}
