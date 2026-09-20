//
//  PhotoCollectionViewCell.swift
//  DoT
//
//  Created by 이중엽 on 3/23/24.
//

import UIKit
import SnapKit

class PhotoCollectionViewCell: BaseCollectionViewCell {
    
    let photoImageView = UIImageView()
    
    override func configureHierarchy() {
        
        contentView.addSubview(photoImageView)
    }
    
    override func configureLayout() {
        
        photoImageView.snp.makeConstraints {
            
            $0.edges.equalTo(contentView)
        }
    }
    
    override func configureView() {
        
        contentView.backgroundColor = .clear
        photoImageView.image = .photoLayout
        photoImageView.tintColor = .white
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.layer.cornerRadius = 10
        photoImageView.layer.masksToBounds = true
        photoImageView.isUserInteractionEnabled = true
    }
}
