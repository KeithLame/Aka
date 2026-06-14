//
//  TripCardCollectionReusableView.swift
//  DoT
//
//  Created by 이중엽 on 3/19/24.
//

import UIKit
import SnapKit

class TripCardCollectionReusableView: UICollectionReusableView {
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureHierarchy() {
        
        [titleLabel].forEach { addSubview($0) }
    }
    
    private func configureLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self).inset(10)
            $0.leading.equalTo(self).inset(10)
            $0.bottom.equalTo(self).inset(10)
        }
    }
    
    private func configureView() {
        
        titleLabel.configure(text: "", fontSize: .regular, fontScale: .Bold)
    }
    
    func configure(_ date: String) {
        
        titleLabel.text = date
    }
}
