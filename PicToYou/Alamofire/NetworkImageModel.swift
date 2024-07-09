import UIKit
import RealmSwift

struct Urls: Codable {
    let raw, full, regular, small, thumb: String?
}

struct User: Codable {
    let id: String?
    let username, name: String?
    let location: String?
}

struct NetworkImageModel: Codable {
    let id: String?
    let views: Int?
    let downloads: Int?
    let likes: Int?
    let urls: Urls?
    let user: User?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case urls
        case user, views, downloads, likes
    }
}

extension NetworkImageModel {
    func toRealmObject() -> Object {
        FavouriteImageModel(value: self)
    }
}
