//
//  ExpenseViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import UIKit

final class ExpenseViewController: BaseViewController<ExpenseView> {
    
    let expenseVM = ExpenseViewModel()
    private var categoryDataSource: UICollectionViewDiffableDataSource<CategoryCompositionalLayout, ExpenseCategory>!
    private var numberPadDataSource: UICollectionViewDiffableDataSource<NumberPadCompositionalLayout, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    override func bindData() {
        
        // 금액 설정 및 view configure
        expenseVM.outputAmountListener.bind { [weak self] amount in
            
            guard let self, let tripInfo = expenseVM.tripInfo else { return }
            
            let type = expenseVM.expenseViewType
            
            layoutView.configre(data: tripInfo, amount: amount, viewType: type)
            layoutView.saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        }
        
        // NumberPad 입력값
        expenseVM.ouputNumberPadListener.bind { [weak self] number in
            
            guard let self else { return }
            
            layoutView.expenseLabel.text = number
        }
        
        // Category 선택
        expenseVM.outputCategoryButtonClickedListener.bind { [weak self] category in
            
            guard let self, let category else { return }
            
            for idx in 0 ..< ExpenseCategory.allCases.count {
                let indexPath = IndexPath(item: idx, section: 0)
                guard let cell = layoutView.categoryCollectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
                cell.update(data: category)
            }
        }
        
        // 저장 버튼 클릭
        expenseVM.outputSaveButtonClickedListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            navigationController?.popViewController(animated: true)
        }
        
        // 저장 버튼 활성화 여부 체크
        expenseVM.outputCheckSaveButtonEnabledListener.bind { [weak self] isEnabled in
            
            guard let self else { return }
            
            layoutView.saveButton.isEnabled = isEnabled
        }
    }
    
    override func configureCollectionView() {
        
        layoutView.categoryCollectionView.showsHorizontalScrollIndicator = false
        
        // MARK: Category Collecion View
        let categoryRegistration = UICollectionView.CellRegistration<CategoryCollectionViewCell, ExpenseCategory> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self else { return }
            
            cell.configure(data: itemIdentifier)
            cell.categoryButton.tag = indexPath.item
            cell.categoryButton.addTarget(self, action: #selector(self.categoryButtonClicked), for: .touchUpInside)
        }
        
        categoryDataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.categoryCollectionView) {collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: categoryRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            
            return cell
        }
        
        // MARK: NumberPad Collecion View
        layoutView.numberPadCollectionView.isScrollEnabled = false
        
        let numberPadRegistration = UICollectionView.CellRegistration<NumberPadCollectionViewCell, String> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self else { return }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(numberPadTapped))
            
            cell.configure(data: itemIdentifier)
            cell.numberLabel.addGestureRecognizer(tapGesture)
        }
        
        numberPadDataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.numberPadCollectionView) {collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: numberPadRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            
            return cell
        }
    }
    
    override func configure() {
        
        expenseVM.inputAmountListener.data = ()
        expenseVM.inputCheckSaveButtonEnabledListener.data = ()
    }
    
    @objc private func saveButtonClicked(sender: UIButton) {
        
        self.expenseVM.inputSaveButtonClickedListener.data = ()
    }
    
    @objc private func categoryButtonClicked(sender: UIButton) {
        
        guard let category = ExpenseCategory(rawValue: sender.tag) else { return }
        
        expenseVM.inputCategoryButtonClickedListener.data = category
    }
    
    @objc private func numberPadTapped(sender: UITapGestureRecognizer) {
        
        guard let label = sender.view as? UILabel,
              let input = label.text,
              let inputText = layoutView.expenseLabel.text else { return }
        
        expenseVM.inputNumberPadListener.data = (input, inputText)
        expenseVM.inputCheckSaveButtonEnabledListener.data = ()
    }
}

extension ExpenseViewController {
    
    private func update() {
        
        var snapshot = NSDiffableDataSourceSnapshot<CategoryCompositionalLayout, ExpenseCategory>()
        snapshot.appendSections([.category])
        
        snapshot.appendItems(ExpenseCategory.allCases, toSection: .category)
        
        self.categoryDataSource.apply(snapshot, animatingDifferences: true)
        
        var numberPadSnapshot = NSDiffableDataSourceSnapshot<NumberPadCompositionalLayout, String>()
        numberPadSnapshot.appendSections([.numberPad])
        
        numberPadSnapshot.appendItems(["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "X"], toSection: .numberPad)
        
        self.numberPadDataSource.apply(numberPadSnapshot, animatingDifferences: true)
    }
}
