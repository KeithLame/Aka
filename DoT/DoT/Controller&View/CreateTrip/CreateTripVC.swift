//
//  CreateTripViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/9/24.
//

import UIKit

class CreateTripViewController: BaseViewController<CreateTripView> {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureNavigation() {
        
        let symbolImage = UIImage.symbol
        let symbolBarButtonItem = UIBarButtonItem(image: symbolImage, style: .plain, target: nil, action: nil)
        symbolBarButtonItem.isEnabled = false
        
        navigationItem.leftBarButtonItem = symbolBarButtonItem
        navigationItem.rightBarButtonItem = makeRightBarButtonItem()
    }
    
    @objc private func createTripButtonClicked() {
        
    }
}

extension CreateTripViewController {
    
    private func makeRightBarButtonItem() -> UIBarButtonItem {
        
        let title = "새로운 여행 등록하기"
        
        var titleAttr = AttributedString.init(title)
        titleAttr.font = FontManager.getFont(size: .small, scale: .Bold)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        let createTripCustomView = UIButton()
        
        let buttonImage = UIImage.plane.withTintColor(.blackWhite, renderingMode: .alwaysOriginal)
        
        buttonConfiguration.image = buttonImage
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.imagePlacement = .leading
        buttonConfiguration.title = title
        buttonConfiguration.attributedTitle = titleAttr
        buttonConfiguration.baseForegroundColor = .blackWhite
        buttonConfiguration.baseBackgroundColor = .clear
        
        createTripCustomView.configuration = buttonConfiguration
        createTripCustomView.addTarget(self, action: #selector(createTripButtonClicked), for: .touchUpInside)
        
        let createTripBarButton = UIBarButtonItem(customView: createTripCustomView)
        return createTripBarButton
    }
}
