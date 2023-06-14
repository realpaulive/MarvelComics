import UIKit

class CoordinatorFactory {
    func createOnboardingCoordinator(presenter: UINavigationController) -> OnboardingCoordinator {
        OnboardingCoordinator(presenter: presenter)
    }
    
    func createLoginCoordinator(presenter: UINavigationController) -> LoginCoordinator {
        LoginCoordinator(presenter: presenter)
    }
    
    func createRegistrationCoordinator(presenter: UINavigationController) -> RegistrationCoordinator {
        RegistrationCoordinator(presenter: presenter)
    }
    
    func createMainCoordinator(presenter: UINavigationController, user: User) -> MainCoordinator {
        MainCoordinator(presenter: presenter, user: user)
    }
}
