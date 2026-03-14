//
//  CategoryCollectionViewCell.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import UIKit
import SnapKit

class CategoryCollectionViewCell: BaseCollectionViewCell {
    
    let categoryButton = UIButton()
    
    override func configureHierarchy() {
        
        [categoryButton].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        categoryButton.snp.makeConstraints {
            $0.edges.equalTo(contentView)
            $0.height.equalTo(32)
        }
    }
    
    override func configureView() {
        
        
        categoryButton.configure(title: "", image: nil, fontSize: .regular, backgroundColor: .blackWhite, foregroundColor: .whiteBlack)
    }
    
    func configure(data: ExpenseCategory) {
        
        categoryButton.configuration?.title = data.rawValue
    }
}
