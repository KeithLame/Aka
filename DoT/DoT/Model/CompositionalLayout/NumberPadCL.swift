//
//  NumberPadCompositionalLayout.swift
//  DoT
//
//  Created by 이중엽 on 3/18/24.
//

import UIKit

enum NumberPadCompositionalLayout: Int, CaseIterable {
    
    case numberPad
    
    static func create() -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            
            return createNumberPad()
        }
        
        return layout
    }
    
    private static func createNumberPad() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 3.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0 / 4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
}

