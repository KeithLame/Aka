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
        symbolBarButtonItem.isEnabled = false
        
        return symbolBarButtonItem
    }
    
    func makeRightBarButtonItem(title: String) -> UIBarButtonItem {
        
        let createCustomView = UIButton()
        let buttonImage = UIImage.plane
        
        createCustomView.configure(title: title, image: buttonImage, fontSize: .small, fontScale: .Bold, backgroundColor: .clear, foregroundColor: .blackWhite, imageColor: .blackWhite)
        createCustomView.addTarget(self, action: #selector(rightBarButtonClicked), for: .touchUpInside)
        
        let createBarButton = UIBarButtonItem(customView: createCustomView)
        return createBarButton
    }
    
    func makeBackBarButton() {
        let backButton = UIBarButtonItem(title: "돌아가기", style: .plain, target: nil, action: nil)
        backButton.setTitleTextAttributes([.font : FontManager.getFont(size: .small, scale: .Bold)], for: .normal)
        navigationItem.backBarButtonItem = backButton
        navigationItem.backBarButtonItem?.tintColor = .blackWhite
    }
    
    @objc func rightBarButtonClicked(_ sender: UIButton) {
        
    }
}
