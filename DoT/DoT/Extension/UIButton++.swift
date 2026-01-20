//
//  UIButton++.swift
//  DoT
//
//  Created by 이중엽 on 3/10/24.
//

import UIKit

extension UIButton {
    
    func configure(title: String, scale: Consts.FontScale = .Medium) {
        
        let buttonTitle = title
        var titleAttrribute = AttributedString.init(buttonTitle)
        titleAttrribute.font = FontManager.getFont(size: .regular, scale: scale)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.title = title
        buttonConfiguration.attributedTitle = titleAttrribute
        buttonConfiguration.baseForegroundColor = .justWhite
        buttonConfiguration.background.backgroundColor = .pointBlue
        self.configuration = buttonConfiguration
    }
    
    func configure(image: UIImage?) {
        
        let imageConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let image = image?.withConfiguration(imageConfiguration).withTintColor(.justWhite, renderingMode: .alwaysOriginal)
        
        var buttonConfigure = UIButton.Configuration.plain()
        buttonConfigure.background.backgroundColor = .pointBlue
        buttonConfigure.image = image
        self.configuration = buttonConfigure
    }
    
    func configure(title: String, image: UIImage?, fontSize: Consts.FontSize = .regular, fontScale: Consts.FontScale = .Medium, backgroundColor: UIColor = .pointBlue, foregroundColor: UIColor = .justWhite, buttonColor: UIColor = .justWhite) {
        
        let buttonTitle = title
        var titleAttrribute = AttributedString.init(buttonTitle)
        titleAttrribute.font = FontManager.getFont(size: fontSize, scale: fontScale)
        
        let imageConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let image = image?.withConfiguration(imageConfiguration).withTintColor(buttonColor, renderingMode: .alwaysOriginal)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.title = title
        buttonConfiguration.attributedTitle = titleAttrribute
        buttonConfiguration.baseForegroundColor = foregroundColor
        buttonConfiguration.background.backgroundColor = backgroundColor
        buttonConfiguration.image = image
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.imagePlacement = .leading
        self.configuration = buttonConfiguration
    }
}

