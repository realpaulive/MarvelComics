import UIKit

class AppCoordinator: Parent {
    
    var presenter: UINavigationController
    
    let coordinatorFactory: CoordinatorFactory
    
    var childCoordinators: [Coordinator] = []
    
    var user: User?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.coordinatorFactory = CoordinatorFactory()
    }
    
    
    func start() {
        runLoginFlow()
        if UserDefaults.standard.value(forKey: "isViewEverSeen") == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.runOnboardingFlow()
            }
        }
    }
    
    func runOnboardingFlow() {
        let onboardingCoordinator = coordinatorFactory.createOnboardingCoordinator(presenter: presenter)
        onboardingCoordinator.flowFinished = { [weak self] in
            self?.removeDependency(onboardingCoordinator)
            self?.presenter.presentedViewController?.dismiss(animated: true)
        }
        addDependency(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func runLoginFlow() {
        let loginCoordinator = coordinatorFactory.createLoginCoordinator(presenter: presenter)
        loginCoordinator.flowFinished = { [weak self] user in
            self?.user = user
            self?.removeDependency(loginCoordinator)
            self?.runMainFlow()
        }
        addDependency(loginCoordinator)
        loginCoordinator.start()
    }
    
    func runMainFlow() {
        user = User(login: "Paul", password: "1234")
        guard let user = user else { return }
        let mainCoordinator = coordinatorFactory.createMainCoordinator(presenter: presenter, user: user)
        addDependency(mainCoordinator)
        mainCoordinator.start()
    }
}
