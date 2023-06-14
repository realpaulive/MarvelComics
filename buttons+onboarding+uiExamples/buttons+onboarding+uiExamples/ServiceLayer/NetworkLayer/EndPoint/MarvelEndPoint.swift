import Foundation

public enum MarvelApi {
    case characters(page: Int)
    case comics(page: Int)
    case creators(page: Int)
    case events(page: Int)
    case series(page: Int)
    case stories(page: Int)
}

extension MarvelApi: EndPointType {
    
    var environmentBaseURL : String {
        return TransferProtocol.secure.rawValue + Host.marvel.rawValue
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .characters: return Request.characters.rawValue
        case .comics: return Request.comics.rawValue
        case .creators: return Request.creators.rawValue
        case .events: return Request.events.rawValue
        case .series: return Request.series.rawValue
        case .stories: return Request.stories.rawValue
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    func createTask(forPage page: Int) -> HTTPTask {
        let timeStamp = "1"
        let publicApiKey = MarvelKey.publicKey
        let privateApiKey = MarvelKey.privateKey
        let hash = CryptoService().createHash(timeStamp, publicKey: publicApiKey, privateKey: privateApiKey)
        let pagination = 20 * page
        return .requestParameters(bodyParameters: nil, urlParameters: ["ts" : timeStamp,
                                                                       "apikey" : publicApiKey,
                                                                       "hash" : hash,
                                                                       "offset" : pagination])
    }
    
    var task: HTTPTask  {
//        let timeStamp = "1"
//        let publicApiKey = MarvelKey.publicKey
//        let privateApiKey = MarvelKey.privateKey
//        let hash = CryptoService().createHash(timeStamp, publicKey: publicApiKey, privateKey: privateApiKey)
//        return .requestParameters(bodyParameters: nil, urlParameters: ["ts" : timeStamp,
//                                                                       "apikey" : publicApiKey,
//                                                                       "hash" : hash])
        switch self {
        case .characters(page: let page):
            return createTask(forPage: page)
        case .comics(page: let page):
            return createTask(forPage: page)
        case .creators(page: let page):
            return createTask(forPage: page)
        case .events(page: let page):
            return createTask(forPage: page)
        case .series(page: let page):
            return createTask(forPage: page)
        case .stories(page: let page):
            return createTask(forPage: page)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
