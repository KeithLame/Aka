//
//  ExchangeRateCollectionReusableView.swift
//  DoT
//
//  Created by 이중엽 on 3/13/24.
//

import UIKit
import SnapKit

class ExchangeRateCollectionReusableView: UICollectionReusableView {
    
    let titleLabel = UILabel()
    let currencyLabel = UILabel()
    let exchangeLabel = UILabel()
    let separateView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureHierarchy() {
        
        [titleLabel, currencyLabel, exchangeLabel, separateView].forEach { addSubview($0) }
    }
    
    private func configureLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self).inset(40)
            $0.leading.equalTo(self).inset(10)
        }
        
        currencyLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(self).inset(10)
        }
        
        exchangeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.trailing.equalTo(self).inset(20)
            $0.bottom.equalTo(self).inset(20)
        }
        
        separateView.snp.makeConstraints {
            $0.bottom.equalTo(self)
            $0.leading.equalTo(self).inset(10)
            $0.height.equalTo(0.5)
            $0.width.equalTo(20)
        }
    }
    
    private func configureView() {
        
        titleLabel.configure(text: "환율", fontSize: .large, fontScale: .Bold)
        currencyLabel.configure(text: "통화", fontSize: .medium, fontScale: .Bold)
        exchangeLabel.configure(text: "오늘의 환율", fontSize: .medium, fontScale: .Bold)
        
        exchangeLabel.textAlignment = .left
        separateView.backgroundColor = .blackWhite
    }
}
