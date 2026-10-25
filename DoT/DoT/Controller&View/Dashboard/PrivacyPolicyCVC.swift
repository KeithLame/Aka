//
//  PrivacyPolicyCollectionViewCell.swift
//  DoT
//
//  Created by 이중엽 on 3/24/24.
//

import UIKit
import SnapKit

class PrivacyPolicyCollectionViewCell: BaseCollectionViewCell {
    
    let privacyPolicyLinkLabel = UILabel()
    
    override func configureHierarchy() {
        
        contentView.addSubview(privacyPolicyLinkLabel)
    }
    
    override func configureLayout() {
        
        privacyPolicyLinkLabel.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
    
    override func configureView() {
        
        privacyPolicyLinkLabel.configure(text: "개인정보처리방침", fontSize: .small, fontScale: .Medium, color: .justGray)
        
        privacyPolicyLinkLabel.textAlignment = .center
    }
}
