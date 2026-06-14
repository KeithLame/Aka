//
//  PlusCollectionViewCell.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import UIKit
import SnapKit

final class PlusCollectionViewCell: BaseCollectionViewCell {
    
    let layoutView = UIView()
    let plusImageView = UIImageView()
    let titleLabel = UILabel()
    
    override func configureHierarchy() {
        
        contentView.addSubview(layoutView)
        
        [plusImageView, titleLabel].forEach { layoutView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        layoutView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        plusImageView.snp.makeConstraints {
            
            $0.top.equalTo(layoutView).inset(30)
            $0.centerX.equalTo(layoutView)
            $0.height.width.equalTo(layoutView.snp.width).dividedBy(5)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(plusImageView.snp.bottom).offset(30)
            $0.centerX.equalTo(layoutView)
            $0.bottom.equalTo(layoutView).inset(20)
        }
    }
    
    override func configureView() {
        
        layoutView.layer.cornerRadius = 10
        layoutView.backgroundColor = .pointBlue
        layoutView.layer.masksToBounds = true
        layoutView.isUserInteractionEnabled = true
        
        titleLabel.configure(text: "현재 진행중인 여행이 없습니다\n새로운 여행을 추가하세요", fontSize: .small, fontScale: .Bold, color: .justWhite)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        let imageConfiguration = UIImage.SymbolConfiguration(font: FontManager.getFont(size: .large, scale: .Medium), scale: .large)
        plusImageView.image = UIImage(systemName: "plus")?.withTintColor(.justWhite, renderingMode: .alwaysOriginal).withConfiguration(imageConfiguration)
        plusImageView.isUserInteractionEnabled = true
    }
}
