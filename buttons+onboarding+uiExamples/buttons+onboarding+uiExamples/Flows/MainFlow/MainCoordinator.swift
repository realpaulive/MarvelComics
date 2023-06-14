import UIKit

final class MainCoordinator: Coordinator {
    
    let user: User
   
    var image: UIImage?
    var comic: Comic?
    
    var presenter: UINavigationController
    
    let moduleFactory: ModuleFactory
    
    init(presenter: UINavigationController, user: User) {
        self.presenter = presenter
        self.user = user
        self.moduleFactory = ModuleFactory()
    }
    
    func start() {
        showMainViewController()
    }
    
    func showMainViewController() {
        let controller = moduleFactory.createMarvelMainModule(viewModel: MarvelMainViewModel())
        
        controller.completionHandler = { [weak self] comic in
            self?.comic = comic
            self?.showComicDetailModule(comic: comic)
        }
        
        presenter.setViewControllers([controller], animated: true)
    }
    
    func showComicDetailModule(comic: Comic) {
        let viewModule = ComicDetailViewModel(comic: comic)
        let controller = ComicDetailViewController(viewModel: viewModule)
        
        controller.completion = { [weak self] image in
            self?.image = image
            self?.showImageModule(image: image, fromController: controller)
        }
        presenter.pushViewController(controller, animated: true)
    }
    
    func showImageModule(image: UIImage, fromController: ZoomAnimatorDelegate) {
        let controller = ImageZoomViewController(image: image)
        self.presenter.delegate = controller.transitionController
        controller.transitionController.fromDelegate = fromController
        controller.transitionController.toDelegate = controller
        
        presenter.pushViewController(controller, animated: true)
    }
    
}
