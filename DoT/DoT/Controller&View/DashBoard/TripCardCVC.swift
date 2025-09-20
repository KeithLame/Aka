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
    let budgetLabel = UILabel()
    let remainBudgetLabel = UILabel()
    
    override func configureHierarchy() {
        
        contentView.addSubview(layoutView)
        
        [periodLabel, arrowImageView, titleLabel, currencyLabel, budgetLabel, remainBudgetLabel].forEach {
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
        
        budgetLabel.snp.makeConstraints {
            $0.top.equalTo(currencyLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(layoutView).inset(20)
        }
        
        remainBudgetLabel.snp.makeConstraints {
            $0.top.equalTo(budgetLabel.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalTo(layoutView).inset(20)
        }
    }
    
    override func configureView() {
        
        layoutView.layer.cornerRadius = 10
        layoutView.backgroundColor = .pointBlue
        layoutView.layer.masksToBounds = true
        
        periodLabel.configure(text: "", fontSize: .medium, fontScale: .Bold, color: .justWhite)
        titleLabel.configure(text: "", fontSize: .medium, fontScale: .Bold, color: .justWhite)
        currencyLabel.configure(text: "", fontSize: .regular, fontScale: .Bold, color: .justWhite)
        budgetLabel.configure(text: "", fontSize: .huge, fontScale: .Bold, color: .justWhite)
        remainBudgetLabel.configure(text: "", fontSize: .extraLarge, fontScale: .Bold, color: .justBlack)
        
        let imageConfiguration = UIImage.SymbolConfiguration(font: FontManager.getFont(size: .large, scale: .Bold), scale: .large)
        arrowImageView.image = UIImage(systemName: "arrow.right")?.withTintColor(.justWhite, renderingMode: .alwaysOriginal).withConfiguration(imageConfiguration)
        arrowImageView.isUserInteractionEnabled = true
    }
    
    func configure(data: TripInfoRepository) {
        
        let formatStartDate = DateUtil.stringFromDate(data.startDate)
        let formatEndDate = DateUtil.stringFromDate(data.endDate)
        guard let currency = Consts.Currency.currencyByName(name: data.currency) else { return }
        
        periodLabel.text = "\(formatStartDate)   -   \(formatEndDate)"
        titleLabel.text = data.title
        currencyLabel.text = data.currency
        budgetLabel.text = "\(data.budget) \(currency.currency)"
        remainBudgetLabel.text = "\(data.budget) \(currency.currency)"
    }
    
    @objc func tripCardTapped(_ sender: UITapGestureRecognizer) {
        
        print("tap")
    }
}
