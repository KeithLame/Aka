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
    let incDecRateLabel = UILabel()
    
    override func configureHierarchy() {
        
        [currencyLabel, currencyUnitLabel, exchangeRateLabel, incDecRateLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        
        currencyLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(10)
            $0.leading.equalTo(contentView).inset(10)
        }
        
        currencyUnitLabel.snp.makeConstraints {
            $0.leading.equalTo(currencyLabel.snp.trailing).offset(5)
            $0.bottom.equalTo(currencyLabel)
        }
        
        exchangeRateLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(10)
            $0.trailing.equalTo(contentView).inset(20)
            $0.leading.greaterThanOrEqualTo(currencyUnitLabel).offset(10)
        }
        
        incDecRateLabel.snp.makeConstraints {
            $0.top.equalTo(exchangeRateLabel.snp.bottom).offset(5)
            $0.leading.equalTo(exchangeRateLabel)
            $0.bottom.equalTo(contentView).inset(10)
        }
    }
    
    override func configureView() {
        
        currencyLabel.configure(text: "미국 달러", fontSize: .medium, fontScale: .Bold)
        currencyUnitLabel.configure(text: "USD", fontSize: .small, fontScale: .Bold, color: .justGray)
        exchangeRateLabel.configure(text: "1,331원", fontSize: .medium, fontScale: .Bold)
        incDecRateLabel.configure(text: "+ 13.3", fontSize: .small, fontScale: .Bold, color: .pointBlue)
    }
}
