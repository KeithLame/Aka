//
//  NSObject++.swift
//  DoT
//
//  Created by 이중엽 on 3/9/24.
//

import Foundation

extension NSObject {
    
    static var identifier: String {
        return String(describing: self)
    }
}
