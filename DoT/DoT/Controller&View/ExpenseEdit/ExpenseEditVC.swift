//
//  ExpenseEditViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/21/24.
//

import UIKit

class ExpenseEditViewController: BaseViewController<ExpenseEditView> {
    
    private var categoryDataSource: UICollectionViewDiffableDataSource<CategoryCompositionalLayout, ExpenseCategory>!
    let expenseEditVM = ExpenseEditViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        update()
        
        expenseEditVM.inputCheckSaveButtonEnabledListener.data = ()
    }
    
    override func configure() {
        
        layoutView.expenseTextField.addTarget(self, action: #selector(expenseValueChanged), for: .editingChanged)
        layoutView.placeTextField.addTarget(self, action: #selector(placeValueChanged), for: .editingChanged)
        layoutView.editButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        layoutView.memoTextView.delegate = self
        
        layoutView.expenseTextField.delegate = self
        layoutView.placeTextField.delegate = self
    }
    
    override func bindData() {
        
        // Category 선택
        expenseEditVM.outputCategoryButtonClickedListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            let count = ExpenseCategory.allCases.count
            
            // 가지고 있는 모든 카테고리 Cell을 원상태로 복구
            // 선택한 셀만 선택하기 위함
            for idx in 0 ..< count {
                let indexPath = IndexPath(item: idx, section: 0)
                guard let cell = layoutView.categoryCollectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
                cell.categoryButton.isSelected = false
            }
        }
        
        expenseEditVM.outputCheckSaveButtonEnabledListener.bind { [weak self] isEnabled in
            
            guard let self else { return }
            
            layoutView.editButton.isEnabled = isEnabled
        }
    }
    
    override func configureNavigation() {
        
        navigationController?.topViewController?.title = "가나다라"
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
    }
    
    // 지출 변경
    @objc private func expenseValueChanged(_ sender: UITextField) {
        
        guard let input = sender.text else { return }
        
        let result = input.convertDecimalString()
        sender.text = result
        
        expenseEditVM.inputExpenseListener.data = result
        expenseEditVM.inputCheckSaveButtonEnabledListener.data = ()
    }
    
    // 장소 입력
    @objc private func placeValueChanged(_ sender: UITextField) {
        
        guard let place = sender.text else { return }
        
        if place.isWhiteSpace() {
            sender.text = ""
        }
        
        expenseEditVM.inputPlaceListener.data = place
    }
    
    // 카테고리 선택 버튼 클릭
    @objc private func categoryButtonClicked(sender: UIButton) {
        
        guard let category = ExpenseCategory(rawValue: sender.tag) else { return }
        
        expenseEditVM.inputCategoryButtonClickedListener.data = category
        expenseEditVM.inputCheckSaveButtonEnabledListener.data = ()
        
        sender.isSelected = true
    }
    
    @objc private func editButtonClicked(sender: UIButton) {
        
        expenseEditVM.inputEditButtonClickedListener.data = ()
    }
}

extension ExpenseEditViewController: UITextFieldDelegate {
    
    // 소수점 3자리 이상부터는 입력 불가
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField != layoutView.expenseTextField { return true }
        
        guard let text = textField.text else { return true }
        
        return expenseEditVM.limitDecimalPoint(text, range: range.location)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

extension ExpenseEditViewController: UITextViewDelegate {
    
    // 메모 입력
    func textViewDidChange(_ textView: UITextView) {
        
        guard let memo = textView.text else { return }
        
        expenseEditVM.inputMemoListener.data = memo
    }
}

extension ExpenseEditViewController {
    
    private func update() {
        
        var snapshot = NSDiffableDataSourceSnapshot<CategoryCompositionalLayout, ExpenseCategory>()
        snapshot.appendSections([.category])
        
        snapshot.appendItems(ExpenseCategory.allCases, toSection: .category)
        
        self.categoryDataSource.apply(snapshot, animatingDifferences: true)
    }
}
