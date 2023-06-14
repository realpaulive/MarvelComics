import UIKit

final class OnboardingCoordinator: Coordinator {
    
    var presenter: UINavigationController
    var flowFinished: (() -> ())?
    
    private let moduleFactory: ModuleFactory
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        moduleFactory = ModuleFactory()
    }
    
    func start() {
        showOnboardingModule()
    }
    
    private func showOnboardingModule() {
        let controller = moduleFactory.createOnboardingModule(viewModel: OnboardingViewModel())
        controller.completionHandler = { [weak self] seen in
            self?.presenter.presentedViewController?.dismiss(animated: true)
            self?.flowFinished?()
        }
        presenter.present(controller, animated: true)
    }
}
