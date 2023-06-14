import UIKit
import SnapKit

class OnboardingView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.image?.withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, subTitle: String, image: UIImage) {
        self.init()
        titleLabel.text = title
        subTitleLabel.text = subTitle
        imageView.image = image
    }
    
    override func didMoveToSuperview() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(350)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
        }
    }
}
