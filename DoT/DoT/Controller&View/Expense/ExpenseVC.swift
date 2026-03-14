//
//  ExpenseViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import UIKit

class ExpenseViewController: BaseViewController<ExpenseView> {
    
    var categoryDataSource: UICollectionViewDiffableDataSource<CategoryCompositionalLayout, ExpenseCategory>!
    var numberPadDataSource: UICollectionViewDiffableDataSource<NumberPadCompositionalLayout, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    override func configureCollectionView() {
        
        // MARK: Category Collecion View
        let categoryRegistration = UICollectionView.CellRegistration<CategoryCollectionViewCell, ExpenseCategory> { cell, indexPath, itemIdentifier in
            
            cell.configure(data: itemIdentifier)
        }
        
        categoryDataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.expenseCollectionView) {collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: categoryRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            
            return cell
        }
        
        // MARK: NumberPad Collecion View
        
        layoutView.numberPadCollectionView.isScrollEnabled = false
        
        let numberPadRegistration = UICollectionView.CellRegistration<NumberPadCollectionViewCell, String> { cell, indexPath, itemIdentifier in
            
            cell.configure(data: itemIdentifier)
        }
        
        numberPadDataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.numberPadCollectionView) {collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: numberPadRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
            
            return cell
        }
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
        
        numberPadSnapshot.appendItems(["1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "0", "+"], toSection: .numberPad)
        
        self.numberPadDataSource.apply(numberPadSnapshot, animatingDifferences: true)
    }
}
