//
//  ExchangeRateCollectionReusableView.swift
//  DoT
//
//  Created by 이중엽 on 3/13/24.
//

import UIKit
import SnapKit

class ExchangeRateCollectionReusableView: UICollectionReusableView {
    
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
        
        [currencyLabel, exchangeLabel, separateView].forEach { addSubview($0) }
    }
    
    private func configureLayout() {
        
        currencyLabel.snp.makeConstraints {
            $0.top.equalTo(self).inset(10)
            $0.leading.equalTo(self).inset(10)
            $0.bottom.equalTo(self).inset(10)
        }
        
        exchangeLabel.snp.makeConstraints {
            $0.leading.equalTo(currencyLabel.snp.trailing).offset(5)
            $0.bottom.equalTo(currencyLabel)
        }
        
        separateView.snp.makeConstraints {
            $0.bottom.equalTo(self)
            $0.leading.equalTo(self).inset(10)
            $0.height.equalTo(0.5)
            $0.width.equalTo(20)
        }
    }
    
    private func configureView() {
        
        currencyLabel.configure(text: "환율", fontSize: .regular, fontScale: .Bold)
        exchangeLabel.configure(text: "오늘의 환율", fontSize: .small, fontScale: .Medium, color: .justGray)
        
        exchangeLabel.textAlignment = .left
        separateView.backgroundColor = .blackWhite
    }
    
    func configure(_ date: String) {
        
        exchangeLabel.text = date
    }
}
