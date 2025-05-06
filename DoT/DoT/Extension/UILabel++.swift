//
//  UILabel++.swift
//  DoT
//
//  Created by 이중엽 on 3/10/24.
//

import UIKit

extension UILabel {
    
    func configure(text: String, fontSize: Consts.FontSize, fontScale: Consts.FontScale, color: UIColor = .blackWhite, numberOfLines: Int = 1) {
        
        self.text = text
        self.textColor = color
        self.font = FontManager.getFont(size: fontSize, scale: fontScale)
        self.numberOfLines = numberOfLines
        
        let attrString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 12
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}
