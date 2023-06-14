import UIKit
import Kingfisher

final class ComicViewCell: UICollectionViewCell {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.style = .medium
        return ai
    }()
    
    private let comicImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        return label
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupViews()
        setupConstraints()
        activityIndicator.startAnimating()
    }
    
    private func setupViews() {
        clipsToBounds = true
        addSubview(comicImage)
        addSubview(activityIndicator)
        addSubview(titleLabel)
        addSubview(creatorNameLabel)
    }
    
    private func setupConstraints() {
        comicImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(self.bounds.height * 0.7)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(comicImage)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(comicImage.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }
        
        creatorNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }
    }
    
    func setupCell(whithComic comic: Comic) {
        titleLabel.text = comic.title
        creatorNameLabel.text = comic.creators?.items?.first?.name
        getImage(whithURLString: comic.thumbnail?.path, imageExtension: comic.thumbnail?.imageExtension)
    }
    
    private func getImage(whithURLString urlString: String?, imageExtension: String?) {
        guard let urlStr = urlString,
              let imageExt = imageExtension,
              let url = URL(string: urlStr)?.appendingPathExtension(imageExt) else { return }
        let imageResource = ImageResource(downloadURL: url)
        comicImage.kf.setImage(with: imageResource) { result in
            switch result {
            case .success(_):
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            case .failure(_):
                break
            }
        }
    }
}
