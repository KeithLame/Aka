//
//  DashboardViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import UIKit

class DashboardViewController: BaseViewController<DashboardView> {

    var diffableDataSoure: UICollectionViewDiffableDataSource<DashboardCompositionalLayout, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeCellRegisteration()
        apply()
    }
    
    private func makeCellRegisteration() {
        
        layoutView.dashboardCollectionView.register(IntroCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
     
        diffableDataSoure = UICollectionViewDiffableDataSource(collectionView: layoutView.dashboardCollectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? IntroCollectionViewCell else { preconditionFailure() }
            
            return cell
        }
    }
    
    func apply() {
        
        var snapshot = NSDiffableDataSourceSnapshot<DashboardCompositionalLayout, String>()
        snapshot.appendSections([.intro])
        snapshot.appendItems(["123"], toSection: .intro)
        self.diffableDataSoure.apply(snapshot, animatingDifferences: true)
    }
}
