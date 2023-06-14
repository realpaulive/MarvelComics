import UIKit.UIColor

final class SignUpViewModel {
    let validCapacityRules: (Int, Int, Int) = (4, 18, 8)
    let excludeCharacters: CharacterSet = .init(charactersIn: ";<>][=?&,:'`")
    
    let tintColor = UIColor.systemTeal
}
