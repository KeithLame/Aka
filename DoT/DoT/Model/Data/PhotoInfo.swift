//
//  PhotoInfo.swift
//  DoT
//
//  Created by 이중엽 on 3/25/24.
//

import Foundation

struct PhotoInfo: Hashable {
    var objectID: String
    var filename: String
    var assetIdentifier: String
    var data: Data
}
