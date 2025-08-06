//
//  DashboardCompositionalLayout.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import UIKit

enum DashboardCompositionalLayout: Int, CaseIterable {
    
    case intro
    case tripCard
    case exchangeRate
    
    static func create() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { section, environment in
            
            let section = DashboardCompositionalLayout(rawValue: section)
            
            switch section {
            case .intro:
                return section?.createIntro()
            case .tripCard:
                return section?.createTripCard()
            case .exchangeRate:
                return section?.createExchangeRate()
            case nil:
                return nil
            }
        }
    }
    
    private func createIntro() -> NSCollectionLayoutSection {
        
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
    
    private func createTripCard() -> NSCollectionLayoutSection? {
        
        let groupInterPadding: CGFloat = 10
        let leftRightInset: CGFloat = 20
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width - (2 * leftRightInset)),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = groupInterPadding
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    private func createExchangeRate() -> NSCollectionLayoutSection? {
        
        return nil
    }
}
