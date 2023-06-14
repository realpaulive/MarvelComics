import Foundation

class ModuleFactory {
    func createOnboardingModule(viewModel: OnboardingViewModel) -> OnboardingViewController {
        OnboardingViewController(viewModel: viewModel)
    }
    
    func createLoginModule(viewModel: LoginViewModel) -> LoginViewController {
        LoginViewController(viewModel: viewModel)
    }
    
    func createSignUpModule(viewModel: SignUpViewModel) -> SignUpViewController {
        SignUpViewController(viewModel: viewModel)
    }
    
    func createEnterPhoneModule(viewModel: EnterPhoneViewModel) -> EnterPhoneViewController {
        EnterPhoneViewController(viewModel: viewModel)
    }
    
    func createAdditionalInfoModule(viewModel: AdditionalInfoViewModel) -> AdditionalInfoViewController {
        AdditionalInfoViewController(viewModel: viewModel)
    }
    
    func createMarvelMainModule(viewModel: MarvelMainViewModel) -> MarvelMainViewController {
        MarvelMainViewController(viewModel: viewModel)
    }
    
    func createComicDetailModule(viewModel: ComicDetailViewModel) -> ComicDetailViewController {
        ComicDetailViewController(viewModel: viewModel)
    }
}
