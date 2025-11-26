//
//  FontManager.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import UIKit

enum FontManager {
    
    static func getFont(size: Consts.FontSize, scale: Consts.FontScale) -> UIFont {
        
        let font = UIFont(name: "NotoSansKR-\(scale)", size: size.rawValue) ?? .boldSystemFont(ofSize: size.rawValue)
        
        return font
    }
}
