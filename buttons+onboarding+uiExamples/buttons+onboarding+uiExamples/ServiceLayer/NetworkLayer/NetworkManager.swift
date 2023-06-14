import Foundation

struct NetworkManager {
    private let router: NetworkRouter<MarvelApi>
    
    enum NetworkResponse: String, Error {
        case success
        case authenticationError = "You need to be authenticated."
        case badRequest = "Bad request"
        case outdated = "The url you requested is outdated."
        case failed = "Network request failed."
        case noData = "Response returned with no data to decode."
        case unableToDecode = "We could not decode the response."
        case badModel = "Unidentified model type"
    }
    
    enum ResponseResult<String> {
        case success
        case failure(NetworkResponse)
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> ResponseResult<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError)
        case 501...599: return .failure(NetworkResponse.badRequest)
        case 600: return .failure(NetworkResponse.outdated)
        default: return .failure (NetworkResponse.failed)
        }
    }
    
    func getData<T: Decodable>(modelType: T.Type, page: Int, completion: @escaping (Result<T, Error>) -> ()) {
        var marvelApi: MarvelApi
        switch modelType {
        case is MarvelComics.Type:
            marvelApi = .comics(page: page)
        default:
            print(NetworkResponse.badModel.rawValue)
            return
        }
        router.request(marvelApi) {data, response, error in
            if let error {
                completion(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        completion(.failure(NetworkResponse.noData))
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(apiResponse))
                    } catch {
                        completion(.failure(NetworkResponse.unableToDecode))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    init(router: NetworkRouter<MarvelApi>) {
        self.router = router
    }
}
 
