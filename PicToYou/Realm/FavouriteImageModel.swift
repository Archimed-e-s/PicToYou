import Foundation
import RealmSwift

class FavouriteImageModel: Object, Decodable {
    @objc dynamic var id: UUID = UUID()
    
    @objc dynamic var username: String = ""
    @objc dynamic var name: String = ""
    
    @objc dynamic var photo_small: String = ""
    @objc dynamic var photo_thumbnail: String = ""
    
    @objc dynamic var views: Int = 0
    @objc dynamic var downloads: Int = 0
    @objc dynamic var likes: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

