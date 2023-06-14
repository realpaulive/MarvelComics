//
//  RegistrationCoordinator.swift
//  buttons+onboarding+uiExamples
//
//  Created by Paul Ive on 22.05.23.
//

import UIKit

final class RegistrationCoordinator: Coordinator, RegistrationCoordinatorOutput {
    
    var user: User?
    var finishFlow: ((User?) -> ())?
    
    var presenter: UINavigationController
    var moduleFactory: ModuleFactory
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.moduleFactory = ModuleFactory()
    }
    
    func start() {
        showSignUpModule()
    }
    
    func showSignUpModule() {
        let vc = moduleFactory.createSignUpModule(viewModel: SignUpViewModel())
        vc.backHandler = { [weak self] in
            self?.finishFlow?(nil)
        }
        vc.completion = { [weak self] login, password in
            self?.user = User(login: login, password: password, phone: nil, email: nil, name: nil, birthDay: nil)
            self?.showEnterPhoneModule()
        }
        presenter.pushViewController(vc, animated: true)
    }
    
    func showEnterPhoneModule() {
        let vc = moduleFactory.createEnterPhoneModule(viewModel: EnterPhoneViewModel())
        vc.completion = { [weak self] phone, name in
            self?.user?.phone = phone
            self?.user?.name = name
            self?.showAdditionalInfoModule()
        }
        presenter.pushViewController(vc, animated: true)
    }
    
    func showAdditionalInfoModule() {
        let vc = moduleFactory.createAdditionalInfoModule(viewModel: AdditionalInfoViewModel())
        vc.completion = { [weak self] email, bDay in
            self?.user?.email = email
            self?.user?.birthDay = bDay
            
            //force appendToTestAuth
            User.logins.append((self?.user)!)
            self?.finishFlow?(self?.user)
        }
        presenter.pushViewController(vc, animated: true)
    }
    
}
