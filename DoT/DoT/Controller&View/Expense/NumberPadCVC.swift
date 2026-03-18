//
//  NumberPadCollectionViewCell.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import UIKit
import SnapKit

class NumberPadCollectionViewCell: BaseCollectionViewCell {
    
    let numberLabel = UILabel()
    
    override func configureHierarchy() {
        
        contentView.addSubview(numberLabel)
    }
    
    override func configureLayout() {
        
        numberLabel.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
    
    override func configureView() {
        
        numberLabel.configure(text: "1", fontSize: .huge, fontScale: .Bold)
        numberLabel.textAlignment = .center
        numberLabel.isUserInteractionEnabled = true
    }
    
    func configure(data: String) {
        
        numberLabel.text = data
    }
}
