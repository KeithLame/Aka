//
//  BaseViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import UIKit

class BaseViewController<LayoutView: UIView>: UIViewController {

    var layoutView: LayoutView {
        
        return view as! LayoutView
    }
    
    override func loadView() {
        
        self.view = LayoutView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindData()
        configureNavigation()
        configureCollectionView()
        configure()
    }
    
    func bindData() { }

    func configure() { }
    
    func configureCollectionView() { }
    
    func configureNavigation() { }
    
    func makeSymbolBarButtonItem() -> UIBarButtonItem {
        
        let symbolImage = UIImage.symbol
        
        let symbolBarButtonItem = UIBarButtonItem(image: symbolImage, style: .plain, target: self, action: nil)
        
        return symbolBarButtonItem
    }
    
    func makeRightBarButtonItem(title: String) -> UIBarButtonItem {
        
        let title = title
        
        var titleAttr = AttributedString.init(title)
        titleAttr.font = FontManager.getFont(size: .small, scale: .Bold)
        
        var buttonConfiguration = UIButton.Configuration.plain()
        let createCustomView = UIButton()
        
        let buttonImage = UIImage.plane.withTintColor(.blackWhite, renderingMode: .alwaysOriginal)
        
        buttonConfiguration.image = buttonImage
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.imagePlacement = .leading
        buttonConfiguration.title = title
        buttonConfiguration.attributedTitle = titleAttr
        buttonConfiguration.baseForegroundColor = .blackWhite
        buttonConfiguration.baseBackgroundColor = .clear
        
        createCustomView.configuration = buttonConfiguration
        createCustomView.addTarget(self, action: #selector(rightBarButtonClicked), for: .touchUpInside)
        
        let createBarButton = UIBarButtonItem(customView: createCustomView)
        return createBarButton
    }
    
    @objc func rightBarButtonClicked(_ sender: UIButton) {
        
    }
}
