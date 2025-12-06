//
//  RealmManager.swift
//  DoT
//
//  Created by 이중엽 on 3/11/24.
//

import Foundation
import RealmSwift

final class RealmManager {
    
    private let realm: Realm
    
    init() throws {
        
        self.realm = try Realm()
    }
    
    func realmURL() {
        
        guard let url = realm.configuration.fileURL else { return }
        
        print(url)
    }
    
    func fetch<T: Object>(_ type: T.Type) -> [T] {
        
        let result = realm.objects(T.self)
        
        return Array(result)
    }
    
    func create<T: Object>(_ object: T) throws {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            throw RealmError.objectCreateFailed
        }
    }
    
    func delete<T: Object>(_ object: T) throws {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            throw RealmError.objectDeleteFailed
        }
    }
}
