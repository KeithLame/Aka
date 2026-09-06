//
//  DeleteCollectionViewCell.swift
//  DoT
//
//  Created by 이중엽 on 3/21/24.
//

import UIKit
import SnapKit

final class DeleteCollectionViewCell: BaseCollectionViewCell {
    
    let deleteButton = UIButton()
    
    override func configureHierarchy() {
        
        contentView.addSubview(deleteButton)
    }
    
    override func configureLayout() {
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(30)
            $0.horizontalEdges.bottom.equalTo(contentView).inset(10)
            $0.height.equalTo(44)
        }
    }
    
    override func configureView() {
        
        deleteButton.configure(title: "데이터 삭제", image: nil)
    }
    
    deinit {
        print("DeleteCVC deinit")
    }
}
