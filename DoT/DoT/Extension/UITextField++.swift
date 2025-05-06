//
//  UITextField++.swift
//  DoT
//
//  Created by 이중엽 on 3/10/24.
//

import UIKit

extension UITextField {
    
    
    func configure(placeHolder: String, fontSize: Consts.FontSize = .regular, textAlignment: NSTextAlignment = .right) {
        
        let titlePlaceHolder = placeHolder
        self.textAlignment = textAlignment
        self.placeholder = titlePlaceHolder
        self.keyboardType = .default
        self.textColor = .blackWhite
        self.font = FontManager.getFont(size: fontSize, scale: .Medium)
        self.attributedPlaceholder = NSAttributedString(string: titlePlaceHolder, attributes: [.foregroundColor: UIColor.justGray])
    }
}
