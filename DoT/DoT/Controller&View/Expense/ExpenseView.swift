//
//  ExpenseView.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import UIKit
import SnapKit

class ExpenseView: BaseView {
    
    let symbolLabel = UILabel()
    let expenseLabel = UILabel()
    let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CategoryCompositionalLayout.create())
    let numberPadCollectionView = UICollectionView(frame: .zero, collectionViewLayout: NumberPadCompositionalLayout.create())
    let saveButton = UIButton()

    override func configureHierarchy() {
        
        [symbolLabel, expenseLabel, categoryCollectionView, numberPadCollectionView, saveButton].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        symbolLabel.snp.makeConstraints {
            
            let offset = UIScreen.main.bounds.height / 10
            
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(offset)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
        }
        
        expenseLabel.snp.makeConstraints {
            $0.top.equalTo(symbolLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.snp.centerY).offset(-44)
            $0.horizontalEdges.equalTo(self)
            $0.height.equalTo(32)
        }
        
        numberPadCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom)
            $0.horizontalEdges.equalTo(self)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(numberPadCollectionView.snp.bottom)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(44)
        }
    }
    
    override func configureView() {
        
        symbolLabel.configure(text: "KRW", fontSize: .medium, fontScale: .Bold)
        expenseLabel.configure(text: "0", fontSize: .extraHuge, fontScale: .Bold)
        expenseLabel.adjustsFontSizeToFitWidth = true
        
        categoryCollectionView.backgroundColor = .clear
        numberPadCollectionView.backgroundColor = .clear
        saveButton.configure(title: "지출 추가", image: .plane)
    }
    
    func configre(data: TripInfo, amount: String, viewType: ExpenseViewType) {
        
        guard let currency = Consts.Currency.currencyByName(name: data.currency) else { return }
        symbolLabel.text = currency.name
        expenseLabel.text = amount
        
        switch viewType {
        case .expense:
            saveButton.configuration?.title = "지출 추가"
        case .budgetEdit:
            saveButton.configuration?.title = "예산 수정"
            categoryCollectionView.isHidden = true
        }
    }
}
