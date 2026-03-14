//
//  TripDashboardViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/15/24.
//

import UIKit

class TripDashboardViewController: BaseViewController<TripDashboardView> {
    
    var diffableDataSource: UICollectionViewDiffableDataSource<TripDashboardCompositionalLayout, AnyHashable>!
    var tripDashboardVM = TripDashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    override func configureCollectionView() {
        
        let tripIntroRegistration = UICollectionView.CellRegistration<TripIntroCollectionViewCell, TripIntro> { cell,indexPath,itemIdentifier in
            
            cell.configure(data: itemIdentifier)
        }
        
        let budgetCardRegistration = UICollectionView.CellRegistration<BudgetCardCollectionViewCell, TripInfo> { cell,indexPath,itemIdentifier in
            
            cell.configure(data: itemIdentifier)
            cell.expenseButton.addTarget(self, action: #selector(self.expenseButtonClicked), for: .touchUpInside)
        }
        
        let expenseRegistration = UICollectionView.CellRegistration<ExpenseCollectionViewCell, AnyHashable> { cell,indexPath,itemIdentifier in
            
            
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.tripDashboradCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let section = indexPath.section
            
            switch section {
            case 0:
                
                guard let item: TripIntro = itemIdentifier as? TripIntro else { return nil }
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: tripIntroRegistration, for: indexPath, item: item)
                
                return cell
                
            case 1:
                
                guard let item: TripInfo = itemIdentifier as? TripInfo else { return nil }
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: budgetCardRegistration, for: indexPath, item: item)
                
                return cell
                
            default:
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: expenseRegistration, for: indexPath, item: itemIdentifier)
                
                return cell
                
            }
        })
    }
    
    @objc func expenseButtonClicked(_ sender: UIButton) {
        
        let nextVC = ExpenseViewController()
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension TripDashboardViewController {
    
    private func update() {
        
        let tripIntro = tripDashboardVM.tripIntro
        guard let tripInfo = tripDashboardVM.tripInfoListener.data else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<TripDashboardCompositionalLayout, AnyHashable>()
        snapshot.appendSections([.intro, .budgetCard])
        
        snapshot.appendItems([tripIntro], toSection: .intro)
        snapshot.appendItems([tripInfo], toSection: .budgetCard)
        
        snapshot.appendSections([.expense(section: "20140313")])
        snapshot.appendItems([3], toSection: .expense(section: "20140313"))
        
        snapshot.appendSections([.expense(section: "20140314")])
        snapshot.appendItems([4], toSection: .expense(section: "20140314"))
        
        self.diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func append() {
        
        // 현재상태 snapshot 복사
        var curSnapshot = diffableDataSource.snapshot()
        
        // Section 추가
        curSnapshot.appendSections([.expense(section: "11111")])
        // item 추가
        curSnapshot.appendItems([5])
        
        diffableDataSource.apply(curSnapshot)
    }
}
