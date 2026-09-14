//
//  UIButton++.swift
//  DoT
//
//  Created by 이중엽 on 3/10/24.
//

import UIKit

extension UIButton {
    
    func configure(title: String, image: UIImage?, fontSize: Consts.FontSize = .regular, fontScale: Consts.FontScale = .Medium, backgroundColor: UIColor = .pointBlue, foregroundColor: UIColor = .justWhite, imageColor: UIColor = .justWhite) {
        
        let buttonTitle = title
        var titleAttrribute = AttributedString.init(buttonTitle)
        titleAttrribute.font = FontManager.getFont(size: fontSize, scale: fontScale)
        
        let imageConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let image = image?.withConfiguration(imageConfiguration).withTintColor(imageColor, renderingMode: .alwaysOriginal)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.title = title
        buttonConfiguration.attributedTitle = titleAttrribute
        buttonConfiguration.background.backgroundColor = backgroundColor
        buttonConfiguration.baseForegroundColor = foregroundColor
        buttonConfiguration.image = image
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.imagePlacement = .leading
        
        self.configuration = buttonConfiguration
    }
    
    func updateConfiguration() {
        
        let backgroundColor = self.configuration?.background.backgroundColor
        let foregroundColor = self.configuration?.baseForegroundColor
        
        let updateHandler: UIButton.ConfigurationUpdateHandler = { btn in
            
            switch btn.state {
            case .disabled:
                
                btn.configuration?.background.backgroundColor = UIColor.systemGray
                btn.configuration?.attributedTitle?.foregroundColor = UIColor.justWhite
            default:
                btn.configuration?.background.backgroundColor = backgroundColor
                btn.configuration?.attributedTitle?.foregroundColor = foregroundColor
            }
        }
        
        self.configurationUpdateHandler = updateHandler
    }
    
    func updateConfigurationForCategory() {
        
        let backgroundColor = self.configuration?.background.backgroundColor
        let foregroundColor = self.configuration?.baseForegroundColor
        
        let updateHandler: UIButton.ConfigurationUpdateHandler = { btn in
            
            switch btn.state {
            case .selected:
                
                btn.configuration?.background.backgroundColor = .pointBlue
                btn.configuration?.attributedTitle?.foregroundColor = UIColor.justWhite
            default:
                btn.configuration?.background.backgroundColor = backgroundColor
                btn.configuration?.attributedTitle?.foregroundColor = foregroundColor
            }
        }
        
        self.configurationUpdateHandler = updateHandler
    }
}

