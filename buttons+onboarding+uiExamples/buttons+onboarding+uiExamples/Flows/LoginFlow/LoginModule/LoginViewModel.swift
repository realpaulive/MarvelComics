import UIKit

final class LoginViewModel {
    
    weak var coordinator: LoginCoordinator? {
        didSet {
            coordinator?.user.bind { user in
                self.user.value = user
            }
        }
    }
    
    var user = Observable(User?(nil))
    var isSuccedAuth = Observable(false)
    
    var statusText = Observable("")
    var statusColor = Observable(UIColor())
    
    func userButtonPressed(login: String, password: String) {
        if login != User.logins.last!.login || password != User.logins.last!.password {
            statusText.value = "Authorization failed"
            statusColor.value = .red
        } else {
            statusText.value = "Authorization was successful"
            statusColor.value = .green
            isSuccedAuth.value = true
        }
    }
}
