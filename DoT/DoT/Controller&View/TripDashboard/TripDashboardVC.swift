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
        
        tripDashboardVM.outputDeleteButtonClickedListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func configureCollectionView() {
        
        layoutView.tripDashboradCollectionView.delegate = self
        
        // Trip Intro Cell
        let tripIntroRegistration = UICollectionView.CellRegistration<TripIntroCollectionViewCell, TripIntro> { cell,indexPath,itemIdentifier in
            
            cell.configure(data: itemIdentifier)
        }
        
        // Budget Card Cell
        let budgetCardRegistration = UICollectionView.CellRegistration<BudgetCardCollectionViewCell, TripInfo> { [weak self] cell,indexPath,itemIdentifier in
            
            guard let self else { return }
            
            cell.configure(data: itemIdentifier)
            cell.expenseButton.addTarget(self, action: #selector(expenseButtonClicked), for: .touchUpInside)
            cell.budgetEditButton.addTarget(self, action: #selector(budgetEditButtonClicked), for: .touchUpInside)
        }
        
        // Delete Cell
        let deleteRegistration = UICollectionView.CellRegistration<DeleteCollectionViewCell, String> { [weak self] cell,indexPath,itemIdentifier in
            
            guard let self else { return }
            
            cell.deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        }
        
        // Empty Cell
        let emptyRegistration = UICollectionView.CellRegistration<EmptyCollectionViewCell, String> { cell,indexPath,itemIdentifier in
            
        }
        
        // Expense Cell
        let expenseRegistration = UICollectionView.CellRegistration<ExpenseCollectionViewCell, TripDetailInfo> { [weak self] cell,indexPath,itemIdentifier in
            
            guard let self else { return }
            
            tripDashboardVM.remainBudgetByObjectIDListener.data = itemIdentifier.objectID
            let remainBudget = tripDashboardVM.remainBudget
            cell.configure(data: itemIdentifier, remainBudget: remainBudget)
        }
        
        // Expense Header Cell
        let expenseHeaderRegistration = UICollectionView.SupplementaryRegistration<ExpenseCollectionReusableView>(elementKind: ExpenseCollectionReusableView.identifier) { [weak self] supplementaryView, elementKind, indexPath in
            
            guard let self else { return }
            
            let snapshot = diffableDataSource.snapshot()
            let section = snapshot.sectionIdentifiers[indexPath.section]
            guard let items = snapshot.itemIdentifiers(inSection: section) as? [TripDetailInfo] else { return }
            
            supplementaryView.configure(data: items, title: section.title)
        }
        
        // Section 등록
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: layoutView.tripDashboradCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let lastSectionNumber = TripDashboardCompositionalLayout.lastSectionNumber
            let isExistEmptySeciton = TripDashboardCompositionalLayout.isExistEmptySeciton
            
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
                
            case lastSectionNumber:
                
                guard let item: String = itemIdentifier as? String else { return nil }
                
                let cell = collectionView.dequeueConfiguredReusableCell(using: deleteRegistration, for: indexPath, item: item)
                
                return cell
                
            default:
                
                if isExistEmptySeciton == false {
                    
                    guard let item: TripDetailInfo = itemIdentifier as? TripDetailInfo else { return nil }
                    
                    let cell = collectionView.dequeueConfiguredReusableCell(using: expenseRegistration, for: indexPath, item: item)
                    
                    return cell
                    
                } else {
                    
                    guard let item: String = itemIdentifier as? String else { return nil }
                    
                    let cell = collectionView.dequeueConfiguredReusableCell(using: emptyRegistration, for: indexPath, item: item)
                    
                    return cell
                    
                }
                
            }
        })
        
        // Header 등록
        diffableDataSource.supplementaryViewProvider = { (view, kind, index) in
            
            return view.dequeueConfiguredReusableSupplementary(
                using: expenseHeaderRegistration, for: index)
        }
    }
    
    // 지출 추가 버튼 클릭
    @objc private func expenseButtonClicked(_ sender: UIButton) {
        
        let nextVC = ExpenseViewController()
        nextVC.expenseVM.expenseViewType = .expense
        nextVC.expenseVM.tripInfo = tripDashboardVM.tripInfo
        
        nextVC.expenseVM.complete.bind { [weak self] _ in
            
            guard let self else { return }
            
            let snapshot = diffableDataSource.snapshot()
            diffableDataSource.applySnapshotUsingReloadData(snapshot)
        }
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 예산 변경 버튼 클릭
    @objc private func budgetEditButtonClicked(_ sender: UIButton) {
        
        let nextVC = ExpenseViewController()
        nextVC.expenseVM.expenseViewType = .budgetEdit
        nextVC.expenseVM.tripInfo = tripDashboardVM.tripInfo
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 삭제 버튼 클릭
    @objc private func deleteButtonClicked(_ sender: UIButton) {
        
        let alertTitle = "여행 정보를 모두 삭제합니다"
        let deleteTitle = "삭제"
        let cancelTitle = "취소"
        
        let attributeAlertTitle = NSMutableAttributedString(string: alertTitle)
        let font = FontManager.getFont(size: .medium, scale: .Bold)
        
        attributeAlertTitle.addAttributes([.font: font, .foregroundColor: UIColor.blackWhite], range: (alertTitle as NSString).range(of: alertTitle))
        
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        let deleteButton = UIAlertAction(title: deleteTitle, style: .destructive) { [weak self] _ in
            
            guard let self else { return }
            
            tripDashboardVM.inputDeleteButtonClickedListener.data = ()
        }
        let cancelButton = UIAlertAction(title: cancelTitle, style: .cancel)
        
        alert.setValue(attributeAlertTitle, forKey: "attributedTitle")
        deleteButton.setValue(UIColor.justRed, forKey: "titleTextColor")
        cancelButton.setValue(UIColor.justGray, forKey: "titleTextColor")
        
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
}

extension TripDashboardViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let tripInfo = tripDashboardVM.tripInfo else { return }
        let tripDetail = tripInfo.tripDetail.sorted { $0.expenseDate > $1.expenseDate }
        
        let expenseIndexOfSection = TripDashboardCompositionalLayout.expenseIndexOfSection
        
        for section in expenseIndexOfSection {
            
            if section == indexPath.section {
                
                let nextVC = ExpenseEditViewController()
                nextVC.expenseEditVM.inputTripDetailInfoListener.data = tripDetail[indexPath.item]
                nextVC.expenseEditVM.complete.bind { [weak self] _ in
                    
                    guard let self else { return }
                    
                    let snapshot = diffableDataSource.snapshot()
                    diffableDataSource.applySnapshotUsingReloadData(snapshot)
                }
                
                navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}

extension TripDashboardViewController {
    
    // SectionSnapshot -> Section 열거형
    private func update() {
        
        let tripIntro = tripDashboardVM.tripIntro
        guard let tripInfo = tripDashboardVM.tripInfo else { return }
        
        // 빠른 날짜 순으로 정렬
        let tripDetail = tripInfo.tripDetail.sorted { $0.expenseDate > $1.expenseDate }
        
        var snapshot = NSDiffableDataSourceSnapshot<TripDashboardCompositionalLayout, AnyHashable>()
        snapshot.appendSections([.intro, .budgetCard])
        
        // Section 추가 - Intro
        snapshot.appendItems([tripIntro], toSection: .intro)
        
        // Section 추가 - BudgetCard
        snapshot.appendItems([tripInfo], toSection: .budgetCard)
        
        // Section 추가 - Expense
        for idx in 0 ..< tripDetail.count {
            
            // empty Section은 미리 삭제
            snapshot.deleteSections([.empty])
            TripDashboardCompositionalLayout.isExistEmptySeciton = false
            
            var data = tripDetail[idx]
            data.tripInfo = tripInfo
            
            let newSectionName = DateUtil.getStringFromDate(date: data.expenseDate, format: "yy.MM.dd")
            let isExistSection: Bool = snapshot.sectionIdentifiers.contains(.expense(section: newSectionName))
            
            if isExistSection {
                snapshot.appendItems([data], toSection: .expense(section: newSectionName))
            } else {
                snapshot.appendSections([.expense(section: newSectionName)])
                snapshot.appendItems([data], toSection: .expense(section: newSectionName))
            }
            
            // 추가된 expense Section 저장
            guard let expenseIndexOfSection = snapshot.indexOfSection(.expense(section: newSectionName)) else { return }
            TripDashboardCompositionalLayout.expenseIndexOfSection.insert(expenseIndexOfSection)
        }
        
        // Section 추가 - Empty (Expense가 없는 경우에 한하여)
        if tripDetail.isEmpty {
            snapshot.appendSections([.empty])
            snapshot.appendItems(["empty"], toSection: .empty)
            
            TripDashboardCompositionalLayout.isExistEmptySeciton = true
        }
        
        // Section 추가 - Delete
        snapshot.appendSections([.delete])
        snapshot.appendItems(["delete"], toSection: .delete)
        
        // 마지막 섹션 넘버 저장
        TripDashboardCompositionalLayout.lastSectionNumber = snapshot.numberOfSections - 1
        
        self.diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
}
