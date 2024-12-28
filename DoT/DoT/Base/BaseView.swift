//
//  BaseView.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .whiteBlack
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
}
