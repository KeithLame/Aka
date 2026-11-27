//
//  TripDashboardView.swift
//  DoT
//
//  Created by 이중엽 on 3/15/24.
//

import UIKit
import SnapKit

final class TripDashboardView: BaseView {

    let tripDashboradCollectionView = UICollectionView(frame: .zero, collectionViewLayout: TripDashboardCompositionalLayout.create())
    
    override func configureHierarchy() {
        
        addSubview(tripDashboradCollectionView)
    }
    
    override func configureLayout() {
        
        tripDashboradCollectionView.snp.makeConstraints {
            
            $0.edges.equalTo(self)
        }
    }
    
    override func configureView() {
        
        tripDashboradCollectionView.backgroundColor = .clear
    }
}
