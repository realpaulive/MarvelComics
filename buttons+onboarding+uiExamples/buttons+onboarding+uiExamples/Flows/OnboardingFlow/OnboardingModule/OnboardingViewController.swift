import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    
    var completionHandler: ((Bool) -> ())?
    
    private var isViewEverSeen: Bool
    
    private var viewModel: OnboardingViewModel
    
    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(red: 221/255, green: 97/255, blue: 64/255, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor(red: 221/255, green: 97/255, blue: 64/255, alpha: 0.6)
        pageControl.numberOfPages = viewModel.onboardingViews.count
        
        if #available(iOS 14.0, *) {
            pageControl.allowsContinuousInteraction = false
        }
        pageControl.addTarget(self, action: #selector(swipe(sender:)), for: .valueChanged)
        return pageControl
    }()
    
    //MARK: - Using of custom button
    
    private lazy var startButton = CustomButton(style: .large,
                                                title: "Get Started",
                                                color: .white,
                                                backgroundColor: UIColor(red: 221/255, green: 97/255, blue: 64/255, alpha: 1))
    
    private lazy var nextButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(swipe(sender:)))
        return button
    }()
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        self.isViewEverSeen = true
        UserDefaults.standard.set(isViewEverSeen, forKey: "isViewEverSeen")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSuperView()
        setupViews()
        setDelegates()
        setupSlides(slides: viewModel.onboardingViews)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConstraints()
    }
    
    private func prepareSuperView() {
        nextButton.tintColor = .secondaryLabel
        navigationItem.rightBarButtonItem = nextButton
        view.backgroundColor = .systemBackground
    }
    
    private func setupViews() {
        view.addSubview(startButton)
        view.addSubview(logoImage)
        view.addSubview(pageControl)
        view.addSubview(scrollView)
        
        startButton.addTarget(self, action: #selector(getStarted), for: .touchUpInside)
    }
    
    //MARK: - Objc methods (swipes and presenting)
    
    @objc private func swipe(sender: UIControl) {
        guard scrollView.contentOffset.x != scrollView.contentSize.width else { return }
        if sender is UIPageControl {
            let offsetX = view.frame.width * CGFloat(pageControl.currentPage)
            scrollView.setContentOffset(.init(x: offsetX, y: 0), animated: true)
        } else {
            scrollView.setContentOffset(.init(x: scrollView.contentOffset.x + view.frame.width, y: 0), animated: true)
        }
    }
    
    @objc private func getStarted() {
        completionHandler?(isViewEverSeen)
    }
    
    //MARK: - Scroll view preparing
    
    private func setupSlides(slides: [OnboardingView]) {
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: 475)
        for i in 0..<slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i),
                                     y: 0,
                                     width: view.frame.width,
                                     height: 475)
            scrollView.addSubview(slides[i])
        }
    }
    
    private func setDelegates() {
        scrollView.delegate = self
    }
    
    private func setupConstraints() {
        logoImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
            make.width.equalTo(145)
            make.height.equalTo(27)
        }
        
        scrollView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(475)
            make.top.equalTo(logoImage.snp.bottom)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(scrollView.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(72)
            make.width.equalTo(208)
            make.height.equalTo(58)
        }
    }
}

//MARK: - Page control implemetation & hiding UIBabButtonItem when scroll ends

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        if scrollView.contentOffset.x > scrollView.contentSize.width - view.frame.width * 1.8 {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = nextButton
        }
    }
}
