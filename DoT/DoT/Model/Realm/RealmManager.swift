//
//  RealmManager.swift
//  DoT
//
//  Created by 이중엽 on 3/11/24.
//

import Foundation
import RealmSwift

final class RealmManager<T: Object> {
    
    private let realm: Realm
    
    init() throws {
        
        self.realm = try Realm()
    }
    
    func realmURL() {
        
        guard let url = realm.configuration.fileURL else { return }
        
        print(url)
    }
    
    func fetch() -> [T] {
        
        let result = realm.objects(T.self)
        
        return Array(result)
    }
    
    func create(_ object: T) throws {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            throw RealmError.objectCreateFailed
        }
    }
    
    func delete(_ object: T) throws {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            throw RealmError.objectDeleteFailed
        }
    }
}
