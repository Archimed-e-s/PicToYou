import Foundation
import RealmSwift

class RealmServices {
    func saveData <T: Object> (data: [T]) throws {
        let realm = try Realm()
        realm.beginWrite()
        realm.add(data, update: .all)
        try realm.commitWrite()
    }
    
    func getAllFavouriteObject() throws -> [FavouriteImageModel] {
        let realm = try Realm()
        let objectsReferensce = realm.objects(FavouriteImageModel.self)
        return Array(objectsReferensce)
        
    }
    
}
