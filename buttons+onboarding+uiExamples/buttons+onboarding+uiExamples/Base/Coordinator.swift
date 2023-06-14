import UIKit

protocol Coordinator: AnyObject {
    var presenter: UINavigationController { get }
    func start()
}

