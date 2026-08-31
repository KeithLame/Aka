//
//  EmptyOnComingCollectionViewCell.swift
//  DoT
//
//  Created by 이중엽 on 3/21/24.
//

import UIKit
import SnapKit

final class EmptyOnComingCollectionViewCell: BaseCollectionViewCell {
    
    let layoutView = UIView()
    private let titleLabel = UILabel()
    
    override func configureHierarchy() {
        
        contentView.addSubview(layoutView)
        
        [titleLabel].forEach { layoutView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        layoutView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalTo(layoutView).inset(10)
        }
    }
    
    override func configureView() {
        
        layoutView.layer.cornerRadius = 10
        layoutView.backgroundColor = .pointBlue
        layoutView.layer.masksToBounds = true
        layoutView.isUserInteractionEnabled = true
        
        titleLabel.configure(text: "예정된 여행이 없습니다 ⚠️", fontSize: .small, fontScale: .Bold, color: .justWhite)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
    }
}
