//
//  TripCardCollectionViewCell.swift
//  DoT
//
//  Created by 이중엽 on 3/11/24.
//

import UIKit
import SnapKit

class TripCardCollectionViewCell: BaseCollectionViewCell {
 
    let layoutView = UIView()
    let periodLabel = UILabel()
    let arrowImageView = UIImageView()
    let titleLabel = UILabel()
    let currencyLabel = UILabel()
    let remainBudgetLabel = UILabel()
    
    override func configureHierarchy() {
        
        contentView.addSubview(layoutView)
        
        [periodLabel, arrowImageView, titleLabel, currencyLabel, remainBudgetLabel].forEach {
            layoutView.insertSubview($0, at: 0)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tripCardTapped))
        
        layoutView.addGestureRecognizer(tapGesture)
    }
    
    override func configureLayout() {
        
        layoutView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        periodLabel.snp.makeConstraints {
            $0.top.equalTo(layoutView).inset(15)
            $0.leading.equalTo(layoutView).inset(20)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(periodLabel)
            $0.trailing.equalTo(layoutView).inset(20)
            $0.leading.greaterThanOrEqualTo(periodLabel.snp.trailing).offset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(periodLabel.snp.bottom).offset(10)
            $0.leading.equalTo(layoutView).inset(20)
        }
        
        currencyLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(layoutView).inset(20)
        }
        
        remainBudgetLabel.snp.makeConstraints {
            $0.top.equalTo(currencyLabel.snp.bottom).offset(20)
            $0.horizontalEdges.bottom.equalTo(layoutView).inset(20)
        }
    }
    
    override func configureView() {
        
        layoutView.layer.cornerRadius = 10
        layoutView.backgroundColor = .pointBlue
        layoutView.layer.masksToBounds = true
        
        periodLabel.configure(text: "기간", fontSize: .medium, fontScale: .Bold, color: .justWhite)
        titleLabel.configure(text: "제목", fontSize: .medium, fontScale: .Bold, color: .justWhite)
        currencyLabel.configure(text: "통화", fontSize: .regular, fontScale: .Bold, color: .justWhite)
        remainBudgetLabel.configure(text: "남은 금액", fontSize: .extraLarge, fontScale: .Bold, color: .justWhite)
        
        let imageConfiguration = UIImage.SymbolConfiguration(font: FontManager.getFont(size: .large, scale: .Bold), scale: .large)
        arrowImageView.image = UIImage(systemName: "arrow.right")?.withTintColor(.justWhite, renderingMode: .alwaysOriginal).withConfiguration(imageConfiguration)
        arrowImageView.isUserInteractionEnabled = true
    }
    
    @objc func tripCardTapped(_ sender: UITapGestureRecognizer) {
        
        print("tap")
    }
}
