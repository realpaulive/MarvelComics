import UIKit

final class ImageZoomViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var completion: (() -> ())?
    
    enum ScreenMode {
        case full, normal
    }
    var currentMode: ScreenMode = .normal
    
    var transitionController = ZoomTransitionController()
    private var imageScrollView: ImageScrollView!
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    var singleTapGestureRecognizer: UITapGestureRecognizer!
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.imageScrollView = ImageScrollView(frame: view.frame, image: image)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupGestureRecognizers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        imageScrollView.contentInsetAdjustmentBehavior = .scrollableAxes
        self.singleTapGestureRecognizer.require(toFail: imageScrollView.zoomingTap)
    }
    
    private func setupGestureRecognizers() {
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))
        self.panGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(self.panGestureRecognizer)
        
        self.singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSingleTapWith(gestureRecognizer:)))
        self.view.addGestureRecognizer(self.singleTapGestureRecognizer)
    }
    
    @objc func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            self.imageScrollView.isScrollEnabled = false
            self.transitionController.isInteractive = true
            let _ = self.navigationController?.popViewController(animated: true)
        case .ended:
            if self.transitionController.isInteractive {
                self.imageScrollView.isScrollEnabled = true
                self.transitionController.isInteractive = false
                self.transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        default:
            if self.transitionController.isInteractive {
                self.transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        }
    }
    
    @objc func didSingleTapWith(gestureRecognizer: UITapGestureRecognizer) {
        switch self.currentMode {
        case .full:
            changeScreenMode(to: .normal)
            self.currentMode = .normal
        case .normal:
            changeScreenMode(to: .full)
            self.currentMode = .full
        }
    }
    
    func changeScreenMode(to mode: ScreenMode) {
        switch mode {
        case .full:
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        case .normal:
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    private func setupView() {
        view.addSubview(imageScrollView)
    }
    
    private func setupNavBar() {
        title = "image"
        let navBarAppearence = UINavigationBarAppearance()
        navBarAppearence.backgroundColor = .black.withAlphaComponent(0.7)
        navBarAppearence.backgroundEffect = .none
        navBarAppearence.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance = navBarAppearence
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearence
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: nil)
        let shareButon = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [saveButton, shareButon]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        completion?()
    }
}

extension ImageZoomViewController: ZoomAnimatorDelegate {
    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {
    }
    
    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
    }
    
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        return self.imageScrollView.imageView
    }
    
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        return self.imageScrollView.imageView.frame
    }
}
