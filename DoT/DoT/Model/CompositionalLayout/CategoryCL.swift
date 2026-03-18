//
//  CategoryCompositionalLayout.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import UIKit

enum CategoryCompositionalLayout: Int, CaseIterable {
    
    case category
    
    static func create() -> UICollectionViewCompositionalLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            
            return createCategory()
        }
        
        layout.configuration = config
        
        return layout
    }
    
    private static func createCategory() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                              heightDimension: .absolute(32))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                               heightDimension: .absolute(32))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 10
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        return section
    }
}

