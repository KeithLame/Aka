//
//  PhotoInfoDTO.swift
//  DoT
//
//  Created by 이중엽 on 3/25/24.
//

import Foundation
import RealmSwift

final class PhotoInfoDTO: Object {
    
    @Persisted(primaryKey: true) var objectID: String = UUID().uuidString
    @Persisted var filename: String
    @Persisted var assetIdentifier: String
    @Persisted var data: Data
    
    convenience init(filename: String, assetIdentifier: String, data: Data) {
        self.init()
        
        self.filename = filename
        self.assetIdentifier = assetIdentifier
        self.data = data
    }
    
    func translate() -> PhotoInfo {
        
        return PhotoInfo(objectID: self.objectID, filename: self.filename, assetIdentifier: self.assetIdentifier, data: self.data)
    }
}
