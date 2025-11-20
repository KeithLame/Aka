//
//  DashboardViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import UIKit

final class DashboardViewController: BaseViewController<DashboardView> {
    
    var diffableDataSoure: UICollectionViewDiffableDataSource<DashboardCompositionalLayout, AnyHashable>!
    var header: UICollectionViewDiffableDataSource<DashboardCompositionalLayout, AnyHashable>.SupplementaryViewProvider!
    let dashboardVM = DashboardViewModel()
    let apiVM = APIViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }
    
    override func bindData() {
        
        // Trip Data Fetch From Realm
        dashboardVM.fetchListener.data = ()
        
        // Exchange Data Fetch From API
        apiVM.callExchangeAPIListener.data = ()
        
        // Trip Data Fetch Completion
        dashboardVM.fetchCompleteListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            self.update()
        }
        
        // Exchange Data Fetch Completion
        apiVM.callExchangeAPICompleteListener.bind { [weak self] data in
            
            guard let self else { return }
                
        }
    }
    
    override func configureCollectionView() {
        
        // Intro Section Registration
        let introSectionRegistration = UICollectionView.CellRegistration<IntroCollectionViewCell, InProgressTripData> { cell, indexPath, itemIdentifier in
            
            cell.configure(title: itemIdentifier.title)
        }
        
        // tripCard Section Registration
        let tripCardSectionRegistration = UICollectionView.CellRegistration<TripCardCollectionViewCell, TripInfo> { cell, indexPath, itemIdentifier in
            
            cell.configure(data: itemIdentifier)
        }
        
        // exchangeRate Section Registration
        let exchangeRateSectionRegistration = UICollectionView.CellRegistration<ExchangeRateCollectionViewCell, Int> { cell, indexPath, itemIdentifier in
            
        }
        
        // exchangeRate Header Registration
        let exchangeRateHeaderRegistration = UICollectionView.SupplementaryRegistration<ExchangeRateCollectionReusableView>(elementKind: ExchangeRateCollectionReusableView.identifier) { supplementaryView, elementKind, indexPath in
            
        }
        
        // Cell 등록
        diffableDataSoure = UICollectionViewDiffableDataSource(collectionView: layoutView.dashboardCollectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let section = DashboardCompositionalLayout(rawValue: indexPath.section) else { return nil }
            
            switch section {
            case .intro:
                
                guard let item: InProgressTripData = itemIdentifier as? InProgressTripData else { return nil }
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: introSectionRegistration, for: indexPath, item: item)
                
                return cell
                
            case .tripCard:
                
                guard let item: TripInfo = itemIdentifier as? TripInfo else { return nil }
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: tripCardSectionRegistration, for: indexPath, item: item)
                
                return cell
                
            case .exchangeRate:
                
                guard let item: Int = itemIdentifier as? Int else { return nil }
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: exchangeRateSectionRegistration, for: indexPath, item: item)
                
                return cell
            }
        }
        
        // Header 등록
        diffableDataSoure.supplementaryViewProvider = { (view, kind, index) in
            return self.layoutView.dashboardCollectionView.dequeueConfiguredReusableSupplementary(
                using: exchangeRateHeaderRegistration, for: index)
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
        snapshot.appendSections(DashboardCompositionalLayout.allCases)
        snapshot.appendItems([inProgressDatas], toSection: .intro)
        snapshot.appendItems(allTripInfoDatas, toSection: .tripCard)
        snapshot.appendItems([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15], toSection: .exchangeRate)
        
        self.diffableDataSoure.apply(snapshot, animatingDifferences: true)
    }
}
