//
//  TripDashboardViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/15/24.
//

import UIKit

final class TripDashboardViewController: BaseViewController<TripDashboardView> {
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<TripDashboardCompositionalLayout, AnyHashable>!
    var tripDashboardVM = TripDashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    deinit {
        print("TripDashboardViewController Deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Trip Info Update
        tripDashboardVM.tripInfoUpdateListener.data = ()
    }
    
    override func bindData() {
        
        // Trip Info Update Complete
        tripDashboardVM.tripInfoUpdateCompleteListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            update()
        }
    }
    
    override func configureCollectionView() {
        
        let tripIntroRegistration = UICollectionView.CellRegistration<TripIntroCollectionViewCell, TripIntro> { cell,indexPath,itemIdentifier in
            
            cell.configure(data: itemIdentifier)
        }
        
        let budgetCardRegistration = UICollectionView.CellRegistration<BudgetCardCollectionViewCell, TripInfo> { [weak self] cell,indexPath,itemIdentifier in
            
            guard let self else { return }
            
            cell.configure(data: itemIdentifier)
            cell.expenseButton.addTarget(self, action: #selector(expenseButtonClicked), for: .touchUpInside)
            cell.budgetEditButton.addTarget(self, action: #selector(budgetEditButtonClicked), for: .touchUpInside)
        }
        
        let expenseRegistration = UICollectionView.CellRegistration<ExpenseCollectionViewCell, TripDetailInfo> { [weak self] cell,indexPath,itemIdentifier in
            
            guard let self else { return }
            
            tripDashboardVM.remainBudgetByObjectIDListener.data = itemIdentifier.objectID
            let remainBudget = tripDashboardVM.remainBudget
            cell.configure(data: itemIdentifier, remainBudget: remainBudget)
        }
        
        let expenseHeaderRegistration = UICollectionView.SupplementaryRegistration<ExpenseCollectionReusableView>(elementKind: ExpenseCollectionReusableView.identifier) { [weak self] supplementaryView, elementKind, indexPath in
            
            guard let self else { return }
            
            let snapshot = diffableDataSource.snapshot()
            let section = snapshot.sectionIdentifiers[indexPath.section]
            guard let items = snapshot.itemIdentifiers(inSection: section) as? [TripDetailInfo] else { return }
            
            supplementaryView.configure(data: items, title: section.title)
        }
        
        // Section 등록
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
                
                guard let item: TripDetailInfo = itemIdentifier as? TripDetailInfo else { return nil }
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: expenseRegistration, for: indexPath, item: item)
                
                return cell
                
            }
        })
        
        // Header 등록
        diffableDataSource.supplementaryViewProvider = { (view, kind, index) in
            
            return view.dequeueConfiguredReusableSupplementary(
                using: expenseHeaderRegistration, for: index)
        }
    }
    
    // 지출 추가 버튼 클릭
    @objc func expenseButtonClicked(_ sender: UIButton) {
        
        let nextVC = ExpenseViewController()
        nextVC.expenseVM.expenseViewType = .expense
        nextVC.expenseVM.tripInfo = tripDashboardVM.tripInfo
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 예산 변경 버튼 클릭
    @objc func budgetEditButtonClicked(_ sender: UIButton) {
        
        let nextVC = ExpenseViewController()
        nextVC.expenseVM.expenseViewType = .budgetEdit
        nextVC.expenseVM.tripInfo = tripDashboardVM.tripInfo
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension TripDashboardViewController {
    
    private func update() {
        
        let tripIntro = tripDashboardVM.tripIntro
        guard let tripInfo = tripDashboardVM.tripInfo else { return }
        
        // 빠른 날짜 순으로 정렬
        let tripDetail = tripInfo.tripDetail.sorted { $0.expenseDate > $1.expenseDate }
        
        var snapshot = NSDiffableDataSourceSnapshot<TripDashboardCompositionalLayout, AnyHashable>()
        snapshot.appendSections([.intro, .budgetCard])
        
        snapshot.appendItems([tripIntro], toSection: .intro)
        snapshot.appendItems([tripInfo], toSection: .budgetCard)
        
        for idx in 0 ..< tripDetail.count {
            
            var data = tripDetail[idx]
            
            data.append(tripInfo)
            
            let newSectionName = DateUtil.getStringFromDate(date: data.expenseDate, format: "yy.MM.dd")
            let isExistSection: Bool = snapshot.sectionIdentifiers.contains(.expense(section: newSectionName))
            
            if isExistSection {
                snapshot.appendItems([data], toSection: .expense(section: newSectionName))
            } else {
                snapshot.appendSections([.expense(section: newSectionName)])
                snapshot.appendItems([data], toSection: .expense(section: newSectionName))
            }
        }
        
        self.diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
}
