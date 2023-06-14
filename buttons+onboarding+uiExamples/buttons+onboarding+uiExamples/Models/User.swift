import Foundation

struct User {
    let id = UUID().uuidString
    var login: String
    var password: String
    var phone: String?
    var email: String?
    var name: String?
    var birthDay: String?
}


extension User {
    static var logins = [
        User(login: "realpaulive", password: "12345678", phone: "+79776041910", email: "123@gmai.com", name: "Pavel Ivanov", birthDay: nil)
    ]
}
