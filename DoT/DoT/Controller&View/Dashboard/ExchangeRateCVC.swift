//
//  ExchangeRateCollectionViewCell.swift
//  DoT
//
//  Created by 이중엽 on 3/13/24.
//

import UIKit
import SnapKit

class ExchangeRateCollectionViewCell: BaseCollectionViewCell {
    
    let currencyLabel = UILabel()
    let currencyUnitLabel = UILabel()
    let exchangeRateLabel = UILabel()
    
    override func configureHierarchy() {
        
        [currencyLabel, currencyUnitLabel, exchangeRateLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        
        currencyLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(20)
            $0.leading.equalTo(contentView).inset(10)
        }
        
        currencyUnitLabel.snp.makeConstraints {
            $0.leading.equalTo(currencyLabel.snp.trailing).offset(5)
            $0.bottom.equalTo(currencyLabel)
        }
        
        exchangeRateLabel.snp.makeConstraints {
            $0.top.equalTo(currencyLabel)
            $0.trailing.equalTo(contentView).inset(20)
            $0.leading.greaterThanOrEqualTo(currencyUnitLabel).offset(10)
            $0.bottom.equalTo(contentView).inset(20)
        }
    }
    
    override func configureView() {
        
        currencyLabel.configure(text: "미국 달러", fontSize: .medium, fontScale: .Bold)
        currencyUnitLabel.configure(text: "USD", fontSize: .small, fontScale: .Bold, color: .justGray)
        exchangeRateLabel.configure(text: "1,331원", fontSize: .medium, fontScale: .Bold)
    }
    
    func configure(data: Exchange) {
        
        currencyLabel.text = data.currencyName
        currencyUnitLabel.text = data.currencyUnit
        exchangeRateLabel.text = "\(data.exchangeRate)원"
    }
}
