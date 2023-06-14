import UIKit.UIColor

final class AdditionalInfoViewModel {
    let validCharacterRules: (CharacterSet, CharacterSet) = (.init(charactersIn: "@") ,.init(charactersIn: ";<>][=?&,:'`"))
    
    let tintColor = UIColor.systemTeal
}
