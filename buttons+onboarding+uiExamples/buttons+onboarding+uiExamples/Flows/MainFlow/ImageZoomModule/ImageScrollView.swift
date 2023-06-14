import UIKit

final class ImageScrollView: UIScrollView {
    
    var imageView: UIImageView!
    var zoomingTap: UITapGestureRecognizer!
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        imageView = UIImageView(image: image)
        delegate = self
        setupView()
        setupTapGesture()
        configureFor(imageSize: image.size)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFor(imageSize: CGSize) {
        contentSize = imageSize
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        setCurrentMaxMixZoomScale()
        zoomScale = minimumZoomScale
        
        imageView.addGestureRecognizer(zoomingTap)
        imageView.isUserInteractionEnabled = true
    }
    
    private func setupTapGesture() {
        zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZommingTap))
        zoomingTap.numberOfTapsRequired = 2
    }
    
    // MARK: - Zooming functions
    
    private func setCurrentMaxMixZoomScale() {
        let boundsSize = self.bounds.size
        let imageSize = imageView.bounds.size
        
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)
        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        maximumZoomScale = maxScale
        minimumZoomScale = minScale
    }
    
    // MARK: - Centring image in view
    
    func centerImage() {
        print("Center")
        let boundsSize = self.bounds.size
        var frameToCenter = imageView.frame
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        imageView.frame = frameToCenter
    }
    
    private func setupView() {
        self.addSubview(imageView)
    }
}


// MARK: - Scroll delegates

extension ImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}


// MARK: - Zooming whith double tap

extension ImageScrollView {
    @objc private func handleZommingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        self.zoom(point: location, animated: true)
    }
    
    private func zoom(point: CGPoint, animated: Bool) {
        let currentScale = self.zoomScale
        let minScale = minimumZoomScale
        let maxScale = maximumZoomScale
        
        if (minScale == maxScale && minScale > 1) { return }
        
        let toScale = maxScale
        let finalScale = (currentScale == minScale) ? toScale : minScale
        let zoomRect = zoomRect(scale: finalScale, center: point)
        self.zoom(to: zoomRect, animated: animated)
    }
    
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }
}
