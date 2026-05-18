//
//  BudgetCardCollectionViewCell.swift
//  DoT
//
//  Created by 이중엽 on 3/15/24.
//

import UIKit
import SnapKit

class BudgetCardCollectionViewCell: BaseCollectionViewCell {
    
    let budgetCardLayoutView = UIView()
    let currencyLabel = UILabel()
    let budgetLabel = UILabel()
    let budgetEditButton = UIButton()
    let expenseButton = UIButton()
    
    override func configureHierarchy() {
        
        [budgetCardLayoutView, currencyLabel, budgetLabel, budgetEditButton, expenseButton].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        budgetCardLayoutView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentView)
        }
        
        currencyLabel.snp.makeConstraints {
            $0.top.equalTo(budgetCardLayoutView).inset(20)
            $0.bottom.equalTo(budgetCardLayoutView.snp.centerY).offset(-10)
            $0.horizontalEdges.equalTo(budgetCardLayoutView).inset(20)
        }
        
        budgetLabel.snp.makeConstraints {
            $0.top.equalTo(currencyLabel.snp.centerY).offset(20)
            $0.horizontalEdges.equalTo(budgetCardLayoutView).inset(20)
            $0.bottom.equalTo(budgetCardLayoutView).inset(30)
        }
        
        budgetEditButton.snp.makeConstraints {
            $0.top.equalTo(budgetCardLayoutView.snp.bottom).offset(10)
            $0.leading.equalTo(contentView)
            $0.trailing.equalTo(contentView.snp.centerX).offset(-5)
            $0.height.equalTo(44)
            $0.bottom.equalTo(contentView)
        }
        
        expenseButton.snp.makeConstraints {
            $0.top.equalTo(budgetCardLayoutView.snp.bottom).offset(10)
            $0.leading.equalTo(contentView.snp.centerX).offset(5)
            $0.trailing.equalTo(contentView)
            $0.height.equalTo(44)
            $0.bottom.equalTo(contentView)
        }
    }
    
    override func configureView() {
        
        currencyLabel.configure(text: "KRW", fontSize: .large, fontScale: .Bold, color: .justWhite)
        budgetLabel.configure(text: "100,000,000원", fontSize: .huge, fontScale: .Bold, color: .justWhite)
        
        budgetCardLayoutView.layer.cornerRadius = 10
        budgetCardLayoutView.backgroundColor = .pointBlue
        
        budgetEditButton.configure(title: "예산 수정", scale: .Bold)
        expenseButton.configure(title: "지출", scale: .Bold)
        expenseButton.configuration?.background.backgroundColor = .blackWhite
        expenseButton.configuration?.baseForegroundColor = .whiteBlack
    }
    
    func configure(data: TripInfo) {
        
        currencyLabel.text = data.currency
        
        let tripDetail = data.tripDetail
        
        var expense: Double = 0
        
        for detail in tripDetail {
            expense += detail.expense
        }
        
        let budget = data.budget.convertDouble()
        let remainBudget = budget - expense
        
        let remain = NumberUtil.convertDecimal(remainBudget as NSNumber)
        
        guard let currency = Consts.Currency.currencyByName(name: data.currency) else { return }
        budgetLabel.text = "\(currency.currencySymbol) \(remain)" // MARK: remain으로 변경해야됨
    }
}
