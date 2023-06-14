import Foundation

enum TransferProtocol: String {
    case casual = "http://"
    case secure = "https://"
}

enum Host: String {
    case marvel = "gateway.marvel.com/v1/public"
}

enum MarvelKey {
    static let publicKey = "655a9ab8de2638a61b8f88ad75462458"
    static let privateKey = "fbf0c9cf90a5b7bfc4c86fef8cd6f743addfa323"
}

enum Request: String {
    case characters = "characters"
    case comics = "comics"
    case creators = "creators"
    case events = "events"
    case series = "series"
    case stories = "stories"
}
