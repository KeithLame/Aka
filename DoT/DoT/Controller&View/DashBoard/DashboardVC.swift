//
//  DashboardViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import UIKit

final class DashboardViewController: BaseViewController<DashboardView> {
    
    var diffableDataSoure: UICollectionViewDiffableDataSource<DashboardCompositionalLayout, AnyHashable>!
    let dashboardVM = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func bindData() {
        
        dashboardVM.fetchListener.data = ()
        
        dashboardVM.fetchCompleteListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            self.update()
        }
    }
    
    override func configureCollectionView() {
        
        let introSectionRegistration = UICollectionView.CellRegistration<IntroCollectionViewCell, InProgressTripData> { cell, indexPath, itemIdentifier in
            
            cell.configure(title: itemIdentifier.title)
        }
        
        let tripCardSectionRegistration = UICollectionView.CellRegistration<TripCardCollectionViewCell, TripInfoRepository> { cell, indexPath, itemIdentifier in
            
            cell.configure(data: itemIdentifier)
        }
        
        diffableDataSoure = UICollectionViewDiffableDataSource(collectionView: layoutView.dashboardCollectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let section = DashboardCompositionalLayout(rawValue: indexPath.section) else { return nil }
            
            switch section {
            case .intro:
                
                guard let item: InProgressTripData = itemIdentifier as? InProgressTripData else { return nil }
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: introSectionRegistration, for: indexPath, item: item)
                
                return cell
                
            case .tripCard:
                
                guard let item: TripInfoRepository = itemIdentifier as? TripInfoRepository else { return nil }
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: tripCardSectionRegistration, for: indexPath, item: item)
                
                return cell
                
            case .exchangeRate:
                break
            }
            
            return nil
        }
    }
    
    override func configureNavigation() {
        
        navigationItem.leftBarButtonItem = makeSymbolBarButtonItem()
        navigationItem.rightBarButtonItem = makeRightBarButtonItem(title: "새로운 여행")
    }
    
    override func rightBarButtonClicked(_ sender: UIButton) {
        
        let nextVC = CreateTripViewController()
        let naviVC = UINavigationController(rootViewController: nextVC)
        
        nextVC.createTripVM.dismissCallBack = { [weak self] in
            
            guard let self else { return }
            
            dashboardVM.fetchListener.data = ()
        }
        
        present(naviVC, animated: true)
    }
}

extension DashboardViewController {
    
    private func update() {
        
        let inProgressDatas = dashboardVM.inProgressTripInfoData
        let allTripInfoDatas = dashboardVM.tripInfoDatas
        
        var snapshot = NSDiffableDataSourceSnapshot<DashboardCompositionalLayout, AnyHashable>()
        snapshot.appendSections([.intro, .tripCard])
        snapshot.appendItems([inProgressDatas], toSection: .intro)
        snapshot.appendItems(allTripInfoDatas, toSection: .tripCard)
        
        self.diffableDataSoure.apply(snapshot, animatingDifferences: true)
    }
}
