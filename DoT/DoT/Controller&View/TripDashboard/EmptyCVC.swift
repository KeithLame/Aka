//
//  EmptyCollectionViewCell.swift
//  DoT
//
//  Created by 이중엽 on 3/21/24.
//

import UIKit
import SnapKit

final class EmptyCollectionViewCell: BaseCollectionViewCell {
    
    private let emptyLabel = UILabel()
    
    override func configureHierarchy() {
        
        contentView.addSubview(emptyLabel)
    }
    
    override func configureLayout() {
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(30)
            $0.horizontalEdges.equalTo(contentView).inset(10)
            $0.bottom.equalTo(contentView).inset(100)
        }
    }
    
    override func configureView() {
        
        emptyLabel.configure(text: "아직 입력된 지출 내역이 없습니다", fontSize: .regular, fontScale: .Bold)
        emptyLabel.adjustsFontSizeToFitWidth = true
        emptyLabel.textAlignment = .center
    }
}
