//
//  DashboardViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import UIKit

final class DashboardViewController: BaseViewController<DashboardView> {

    var diffableDataSoure: UICollectionViewDiffableDataSource<DashboardCompositionalLayout, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    override func configureCollectionView() {
        
        layoutView.dashboardCollectionView.register(IntroCollectionViewCell.self, forCellWithReuseIdentifier: IntroCollectionViewCell.identifier)
        layoutView.dashboardCollectionView.register(TripCardCollectionViewCell.self, forCellWithReuseIdentifier: TripCardCollectionViewCell.identifier)
     
        diffableDataSoure = UICollectionViewDiffableDataSource(collectionView: layoutView.dashboardCollectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let section = DashboardCompositionalLayout(rawValue: indexPath.section) else { return nil }
            
            switch section {
            case .intro:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IntroCollectionViewCell.identifier, for: indexPath) as? IntroCollectionViewCell else { preconditionFailure() }
                
                return cell
                
            case .tripCard:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TripCardCollectionViewCell.identifier, for: indexPath) as? TripCardCollectionViewCell else { preconditionFailure() }
                
                return cell
                
            case .exchangeRate:
                break
            }
            
            return UICollectionViewCell()
        }
    }
    
    override func configureNavigation() {
        
        navigationItem.leftBarButtonItem = makeSymbolBarButtonItem()
        navigationItem.rightBarButtonItem = makeRightBarButtonItem(title: "새로운 여행")
    }
    
    override func rightBarButtonClicked(_ sender: UIButton) {
        
        let nextVC = CreateTripViewController()
        let naviVC = UINavigationController(rootViewController: nextVC)
        
        present(naviVC, animated: true)
    }
}

extension DashboardViewController {
    
    private func update() {
        
        var snapshot = NSDiffableDataSourceSnapshot<DashboardCompositionalLayout, String>()
        snapshot.appendSections([.intro, .tripCard])
        snapshot.appendItems(["0"], toSection: .intro)
        snapshot.appendItems(["1", "2", "3", "4"], toSection: .tripCard)
        self.diffableDataSoure.apply(snapshot, animatingDifferences: true)
    }
}
