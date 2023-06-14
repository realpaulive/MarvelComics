import Foundation

// MARK: - MarvelComics
struct MarvelComics: Codable {
    let data: ComicDataContainer?
}

// MARK: - DataClass
struct ComicDataContainer: Codable {
    let offset, limit, total, count: Int?
    let results: [Comic]?
}

// MARK: - Comic
struct Comic: Codable {
    let id: Int?
    let title, description, modified: String?
    let thumbnail: ImageURL?
    let images: [ImageURL]?
    let creators: Creators?
}

// MARK: - Creators
struct Creators: Codable {
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let name, role: String?
}

// MARK: - Thumbnail
struct ImageURL: Codable {
    let path, imageExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
}
