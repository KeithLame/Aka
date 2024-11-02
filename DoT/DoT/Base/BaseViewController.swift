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
}
