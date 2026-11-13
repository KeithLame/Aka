//
//  TripDashboardCompositionalLayout.swift
//  DoT
//
//  Created by 이중엽 on 3/15/24.
//

import UIKit

enum TripDashboardCompositionalLayout: CaseIterable, Hashable {
    
    static var allCases: [TripDashboardCompositionalLayout] = [.budgetCard, .intro]
    
    case intro
    case budgetCard
    case expense(section: String)
    case empty
    
    var title: String {
        switch self {
        case .expense(let section):
            return section
        default: return ""
        }
    }
    
    static var isExistEmptySeciton: Bool = false
    static var expenseIndexOfSection: Set<Int> = []
    
    static func create() -> UICollectionViewCompositionalLayout {
        
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { _, _, completion in
        }
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            
            switch section {
            case 0:
                return createIntro()
            case 1:
                return createBudgetCard()
            default:
                if isExistEmptySeciton == false {
                    return createExpense()
                } else {
                    return createDefault()
                }
            }
        }
        
        
        
        return layout
    }
    
    private static func createIntro() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
    
    private static func createBudgetCard() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
    
    private static func createExpense() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createHeader()]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        return section
    }
    
    private static func createDefault() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        return section
    }
    
    private static func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ExpenseCollectionReusableView.identifier, alignment: .top)
        
        return header
    }
}
