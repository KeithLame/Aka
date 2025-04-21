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
        layoutView.dashboardCollectionView.register(IntroCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
     
        diffableDataSoure = UICollectionViewDiffableDataSource(collectionView: layoutView.dashboardCollectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? IntroCollectionViewCell else { preconditionFailure() }
            
            return cell
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
        snapshot.appendSections([.intro])
        snapshot.appendItems(["0"], toSection: .intro)
        self.diffableDataSoure.apply(snapshot, animatingDifferences: true)
    }
}
