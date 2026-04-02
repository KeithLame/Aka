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
        
        // MARK: DashBoardVM
        
        // Trip Data Fetch From Realm
        dashboardVM.tripInfoFetchListener.data = ()
        
        // Exchange Data Fetch From Realm
        dashboardVM.exchangeFetchListener.data = ()
        
        // Trip Data Fetch Completion
        dashboardVM.tripInfoFetchCompleteListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            update()
        }
        
        // Exchange Data Fetch Completion
        dashboardVM.exchangeFetchCompleteListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            update()
        }
        
        // Add Exchange Data to Realm Completion
        dashboardVM.createExchangeRateCompletionListener.bind { [weak self] isComplete in
            
            guard let self else { return }
            
            if isComplete {
                update()
            }
        }
        
        // MARK: APIVM
        // Exchange Data Fetch From API
        apiVM.callExchangeAPIListener.data = ()
        
        // Exchange Data Fetch Completion
        apiVM.callExchangeAPICompleteListener.bind { [weak self] data in
            
            guard let self else { return }
            
            // 오늘 호출해서 데이터가 저장되어있는지 체크
            if dashboardVM.isCalledToday() {
                return
            } else {
                // 호출 및 저장 안했으면 API 호출
                dashboardVM.createExchangeRateListener.data = data
            }
        }
    }
    
    override func configureCollectionView() {
        
        // Intro Section Registration
        let introSectionRegistration = UICollectionView.CellRegistration<IntroCollectionViewCell, InProgressTrip> { cell, indexPath, itemIdentifier in
            
            cell.configure(title: itemIdentifier.title)
        }
        
        // tripCard Section Registration
        let tripCardSectionRegistration = UICollectionView.CellRegistration<TripCardCollectionViewCell, TripInfo> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self else { return }
            
            cell.configure(data: itemIdentifier)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tripCardTapped))
            cell.layoutView.tag = indexPath.item
            
            cell.layoutView.addGestureRecognizer(tapGesture)
        }
        
        // exchangeRate Section Registration
        let exchangeRateSectionRegistration = UICollectionView.CellRegistration<ExchangeRateCollectionViewCell, ExchangeRealm> { cell, indexPath, itemIdentifier in
            
            cell.configure(data: itemIdentifier)
        }
        
        // exchangeRate Header Registration
        let exchangeRateHeaderRegistration = UICollectionView.SupplementaryRegistration<ExchangeRateCollectionReusableView>(elementKind: ExchangeRateCollectionReusableView.identifier) { supplementaryView, elementKind, indexPath in
            
        }
        
        // Cell 등록
        diffableDataSoure = UICollectionViewDiffableDataSource(collectionView: layoutView.dashboardCollectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let section = DashboardCompositionalLayout(rawValue: indexPath.section) else { return nil }
            
            switch section {
            case .intro:
                
                guard let item: InProgressTrip = itemIdentifier as? InProgressTrip else { return nil }
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: introSectionRegistration, for: indexPath, item: item)
                
                return cell
                
            case .tripCard:
                
                guard let item: TripInfo = itemIdentifier as? TripInfo else { return nil }
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: tripCardSectionRegistration, for: indexPath, item: item)
                
                return cell
                
            case .exchangeRate:
                
                guard let item: ExchangeRealm = itemIdentifier as? ExchangeRealm else { return nil }
                
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
            
            dashboardVM.tripInfoFetchListener.data = ()
        }
        
        present(naviVC, animated: true)
    }
    
    @objc func tripCardTapped(_ sender: UITapGestureRecognizer) {
        
        guard let layoutView = sender.view else { return }
        
        let allTripInfoDatas = dashboardVM.tripInfoDatas
        let nextVC: TripDashboardViewController = TripDashboardViewController()
        makeBackBarButton()
        nextVC.tripDashboardVM.tripInfoListener.data = allTripInfoDatas[layoutView.tag]
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension DashboardViewController {
    
    private func update() {
        
        let inProgressDatas = dashboardVM.inProgressTripInfoData
        let allTripInfoDatas = dashboardVM.tripInfoDatas
        let exchangeDatas = dashboardVM.exchangeDatas
        
        var snapshot = NSDiffableDataSourceSnapshot<DashboardCompositionalLayout, AnyHashable>()
        snapshot.appendSections(DashboardCompositionalLayout.allCases)
        snapshot.appendItems([inProgressDatas], toSection: .intro)
        snapshot.appendItems(allTripInfoDatas, toSection: .tripCard)
        snapshot.appendItems(exchangeDatas, toSection: .exchangeRate)
        
        self.diffableDataSoure.apply(snapshot, animatingDifferences: true)
    }
}
