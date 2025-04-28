//
//  UIButton++.swift
//  DoT
//
//  Created by 이중엽 on 3/10/24.
//

import UIKit

extension UIButton {
    
    func configure(title: String) {
        
        let buttonTitle = title
        var titleAttrribute = AttributedString.init(buttonTitle)
        titleAttrribute.font = FontManager.getFont(size: .regular, scale: .Medium)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.title = title
        buttonConfiguration.attributedTitle = titleAttrribute
        buttonConfiguration.baseForegroundColor = .justWhite
        buttonConfiguration.background.backgroundColor = .pointBlue
        self.configuration = buttonConfiguration
    }
}

