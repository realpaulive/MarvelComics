import Foundation

protocol RegistrationCoordinatorOutput {
    var finishFlow: ((User?)->())? { get set }
}
