import UIKit
import SnapKit
import Kingfisher

class ComicDetailViewController: UIViewController {
    
    var completion: ((UIImage) -> ())?
    let viewModel: ComicDetailViewModel
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:))))
        return imageView
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    lazy private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    lazy private var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    init(viewModel: ComicDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupContent()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        setupConstraints()
    }
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        guard let image = tappedImage.image else { return }
        completion?(image)
    }
    
    private func setupContent() {
        titleLabel.text = viewModel.comic.title
        descriptionLabel.text = viewModel.comic.description
        authorLabel.text = viewModel.comic.creators?.items?.first?.name
        getImage(whithURLString: viewModel.comic.thumbnail?.path, imageExtension: viewModel.comic.thumbnail?.imageExtension)
    }
    
    private func getImage(whithURLString urlString: String?, imageExtension: String?) {
        guard let urlStr = urlString,
              let imageExt = imageExtension,
              let url = URL(string: urlStr)?.appendingPathExtension(imageExt) else { return }
        let imageResource = ImageResource(downloadURL: url)
        imageView.kf.setImage(with: imageResource)
    }
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(authorLabel)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.height.equalTo(230)
            make.width.equalTo(140)
            make.top.equalTo(view.snp.topMargin).offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.width.equalTo(titleLabel)
            make.centerX.equalTo(titleLabel)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.width.equalTo(titleLabel)
            make.centerX.equalTo(titleLabel)
        }
    }
    
    private func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.standardAppearance = UINavigationBarAppearance()
        navigationController?.navigationBar.scrollEdgeAppearance = .none
        navigationController?.navigationBar.tintColor = UIColor.systemTeal
    }
}

extension ComicDetailViewController: ZoomAnimatorDelegate {
    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {
        
    }
    
    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
        
    }
    
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        let referenceImageView = self.imageView
        return referenceImageView
    }
    
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        self.view.layoutIfNeeded()
        return self.imageView.frame
    }
}
