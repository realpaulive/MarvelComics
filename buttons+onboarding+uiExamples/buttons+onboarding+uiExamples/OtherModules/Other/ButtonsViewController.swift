import UIKit
import SnapKit

final class ButtonsViewController: UIViewController {
    
    
    
    private lazy var buttonTitleLabel1: UILabel = {
        let label = UILabel()
        label.text = "Tap first button to see changes"
        return label
    }()
    
    private lazy var buttonTitleLabel2: UILabel = {
        let label = UILabel()
        label.text = "Second button shows highlighted state"
        return label
    }()
    
    private lazy var buttonTitleLabel3: UILabel = {
        let label = UILabel()
        label.text = "Third button shows the enabled/disabled state"
        label.numberOfLines = 2
        return label
    }()
    
    //MARK: - Creating buttons from convenience initializer
    
    private lazy var customButton = CustomButton(style: .large,
                                         title: "First button",
                                         image: UIImage(systemName: "play"),
                                         imageAlignment: .right,
                                         color: .white,
                                         backgroundColor: UIColor.systemPink,
                                         whithShadows: false)
    
    private lazy var customButton2 = CustomButton(style: .medium,
                                          title: "Second button",
                                          image: UIImage(systemName: "sun.max"),
                                          imageAlignment: .right,
                                          color: .white,
                                          backgroundColor: UIColor.systemPink,
                                          whithShadows: false)
    
    private lazy var customButton3 = CustomButton(style: .small,
                                          title: "Third button",
                                          image: UIImage(systemName: "lock.fill"),
                                          imageAlignment: .right,
                                          color: .white,
                                          backgroundColor: UIColor.systemPink,
                                          whithShadows: false)
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "TextFields", style: .plain, target: self, action: #selector(nextPage))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSuperView()
        setupViews()
        prepareButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstraints()
    }
    
    @objc private func nextPage() {
        let vc = TextFieldsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Buttons interacrion
    
    @objc private func turnOn() {
        
        customButton3.isEnabled.toggle()
        customButton3.setImage(UIImage(systemName: "lock.open.fill")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
            .applyingSymbolConfiguration(.init(scale: .small)), for: .normal)
        
        customButton2.isHighlighted.toggle()
        customButton2.setImage(UIImage(systemName: "sun.min")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
            .applyingSymbolConfiguration(.init(scale: .medium)), for: .normal)
        
    }
    
    private func prepareSuperView() {
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Buttons"
        navigationItem.rightBarButtonItem = rightButton
    }
    
    //MARK: - Prepare buttons for interacrion
    
    private func prepareButtons() {
        customButton.addTarget(self, action: #selector(turnOn), for: .touchUpInside)
        customButton2.isHighlighted = true
        customButton3.isEnabled = false
    }
 
    private func setupViews() {
        self.view.addSubview(customButton)
        self.view.addSubview(buttonTitleLabel1)
        self.view.addSubview(customButton2)
        self.view.addSubview(customButton3)
        self.view.addSubview(buttonTitleLabel2)
        self.view.addSubview(buttonTitleLabel3)
    }
    
    private func setupConstraints() {
        
        buttonTitleLabel1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(view.snp.topMargin).offset(16)
        }
        
        customButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(buttonTitleLabel1.snp.bottom).offset(16)
            make.height.equalTo(64)
            make.width.equalTo(280)
        }
        
        buttonTitleLabel2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(customButton.snp.bottom).offset(32)
        }
        
        customButton2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(buttonTitleLabel2.snp.bottom).offset(16)
            make.height.equalTo(48)
            make.width.equalTo(220)
        }
        
        buttonTitleLabel3.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.equalTo(customButton2.snp.bottom).offset(32)
        }
        
        customButton3.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(buttonTitleLabel3.snp.bottom).offset(16)
            make.height.equalTo(32)
            make.width.equalTo(120)
        }
    }
}

