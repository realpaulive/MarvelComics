import Foundation

final class MarvelMainViewModel {
    
    var page: Int = 0 {
        didSet {
            getComics(page: page)
        }
    }
    var comics = Observable([Comic]())
    private let networkManager: NetworkManager
    
    init() {
        self.networkManager = NetworkManager(router: NetworkRouter<MarvelApi>())
    }
    
    func getComics(page: Int) {
        networkManager.getData(modelType: MarvelComics.self, page: page) { [weak self] result in
            switch result {
            case .success(let data):
                guard let comics = data.data?.results else { return }
                self?.comics.value.append(contentsOf: comics)
            case .failure(let error):
                print(error)
            }
        }
    }
}
