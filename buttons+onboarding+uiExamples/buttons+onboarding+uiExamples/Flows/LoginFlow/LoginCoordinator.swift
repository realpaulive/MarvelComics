import UIKit

final class LoginCoordinator: Parent {
    
    var presenter: UINavigationController
    var flowFinished: ((User?) -> ())?
    
    var user = Observable(User?(nil))
    
    private let moduleFactory: ModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    
    var childCoordinators: [Coordinator] = []
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        moduleFactory = ModuleFactory()
        coordinatorFactory = CoordinatorFactory()
    }
    
    func start() {
        showLoginModule()
    }
    
    private func showLoginModule() {
        let viewModel = LoginViewModel()
        let controller = moduleFactory.createLoginModule(viewModel: viewModel)
        controller.registrationHandler = { [weak self] in
            viewModel.coordinator = self
            self?.runRegistrationFlow()
        }
        controller.successAuthHandler = { [weak self] login, password in
            self?.flowFinished?(User(login: login, password: password))
        }
        presenter.setViewControllers([controller], animated: false)
    }
    
    private func runRegistrationFlow() {
        let registarionCoordinator = coordinatorFactory.createRegistrationCoordinator(presenter: presenter)
        registarionCoordinator.finishFlow = { [weak self, weak registarionCoordinator] user in
            self?.removeDependency(registarionCoordinator)
            if let user {
                self?.user.value = user
                self?.presenter.popToRootViewController(animated: true)
            }
        }
        addDependency(registarionCoordinator)
        print(childCoordinators.count)
        registarionCoordinator.start()
    }
}
