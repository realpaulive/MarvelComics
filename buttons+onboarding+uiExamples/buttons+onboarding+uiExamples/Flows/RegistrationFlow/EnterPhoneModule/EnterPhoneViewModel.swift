import UIKit.UIColor

final class EnterPhoneViewModel {
    let validCapacityRules: (Int, Int, Int) = (10, 12, 8)
    let excludeCharacters: CharacterSet = .init(charactersIn: ";<>][=?&,:'`")
    
    let tintColor = UIColor.systemTeal
}
