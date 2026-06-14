//
//  DashboardCompositionalLayout.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import UIKit

enum DashboardCompositionalLayout: Int, CaseIterable {
    
    // case plus
    case tripCard
    case onComing
    case exchangeRate
    
    static func create() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            
            let section = DashboardCompositionalLayout(rawValue: section)
            
            switch section {
            case .tripCard, .onComing:
                return createTripCard()
            case .exchangeRate:
                return createExchangeRate()
            case nil:
                return nil
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        
        layout.configuration = config
        
        return layout
    }
    
    private static func createTripCard() -> NSCollectionLayoutSection {
        
        let ratio: CGFloat = 0.7
        let groupInterSpacing = UIScreen.main.bounds.width * (1.0 - ratio) / 4
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(ratio),
                                               heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = groupInterSpacing
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.boundarySupplementaryItems = [createHeader(TripCardCollectionReusableView.identifier)]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
    
    private static func createExchangeRate() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [createHeader(ExchangeRateCollectionReusableView.identifier)]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
    
    private static func createHeader(_ elementKind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: elementKind, alignment: .top)
        
        return header
    }
}
