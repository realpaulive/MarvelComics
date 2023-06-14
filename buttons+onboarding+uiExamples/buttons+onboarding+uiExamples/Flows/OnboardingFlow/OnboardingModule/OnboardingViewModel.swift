import UIKit

final class OnboardingViewModel {
    let onboardingModel = [OnboardingModel(title: "Friendly Broker",
                                           subTitle: "Friendly broker is a must have if you want to be successful in your financial life.",
                                           image: UIImage(named: "Finances-2")!),
                           OnboardingModel(title: "Great Analytics",
                                           subTitle: "Amazing analytics for you to keep track of your stocks, expenses, savings and your currencies.",
                                           image: UIImage(named: "Finances-1")!),
                           OnboardingModel(title: "Compare Stocks",
                                           subTitle: "Compare your stocks easily with the help of the free buil-in compare feature in the app.",
                                           image: UIImage(named: "Finances")!)]
    
    //MARK: - Views from mock model for addingg in scroll view
    
    var onboardingViews: [OnboardingView] {
        var onboard = [OnboardingView]()
        onboardingModel.forEach { onboarding in
            onboard.append(OnboardingView(title: onboarding.title, subTitle: onboarding.subTitle, image: onboarding.image))
        }
        return onboard
    }
}
