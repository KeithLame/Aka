//
//  DashboardView.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import UIKit
import SnapKit

final class DashboardView: BaseView {
    
    let dashboardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: DashboardCompositionalLayout.create())
    
    override func configureHierarchy() {
        
        addSubview(dashboardCollectionView)
    }
    
    override func configureLayout() {
        
        dashboardCollectionView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
        dashboardCollectionView.backgroundColor = .clear
    }
}
