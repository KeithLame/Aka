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
    
    @objc func numberPadTapped(sender: UITapGestureRecognizer) {
        
        guard let label = sender.view as? UILabel,
              let input = label.text else { return }
        
        
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
