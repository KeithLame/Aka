//
//  TripDashboardViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/15/24.
//

import UIKit

class TripDashboardViewController: BaseViewController<TripDashboardView> {
    
    var diffableDataSource: UICollectionViewDiffableDataSource<TripDashboardCompositionalLayout, AnyHashable>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    override func configureCollectionView() {
        
        let tripIntroRegistration = UICollectionView.CellRegistration<TripIntroCollectionViewCell, AnyHashable> { cell,indexPath,itemIdentifier in
            
            
        }
        
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.tripDashboradCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            guard let section = TripDashboardCompositionalLayout(rawValue: indexPath.section) else { return nil }
            
            switch section {
            case .intro:
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: tripIntroRegistration, for: indexPath, item: itemIdentifier)
                
                return cell
                
            case .budgetCard:
                break
            case .expense:
                break
            }
            
            return nil
        })
    }
}

extension TripDashboardViewController {
    
    private func update() {
        
        var snapshot = NSDiffableDataSourceSnapshot<TripDashboardCompositionalLayout, AnyHashable>()
        snapshot.appendSections(TripDashboardCompositionalLayout.allCases)
        snapshot.appendItems([1], toSection: .intro)
        
        self.diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
}
