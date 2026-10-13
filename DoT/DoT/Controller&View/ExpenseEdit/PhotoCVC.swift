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
    let deleteButton = UIButton()
    
    override func prepareForReuse() {
        
        photoImageView.image = .photoLayout
        photoImageView.isUserInteractionEnabled = true
        deleteButton.isHidden = true
    }
    
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
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 10
        photoImageView.layer.masksToBounds = true
        photoImageView.isUserInteractionEnabled = true
    }
    
    func configure(data: UIImage) {
        
        photoImageView.image = data
        photoImageView.isUserInteractionEnabled = false
        
        contentView.addSubview(deleteButton)
        
        let image = UIImage(systemName: "minus.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        deleteButton.setImage(image, for: .normal)
        deleteButton.isHidden = false
        
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalTo(photoImageView).inset(3)
        }
    }
}
