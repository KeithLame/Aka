//
//  IntroCollectionViewCell.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import UIKit
import SnapKit

final class IntroCollectionViewCell: BaseCollectionViewCell {
    
    let introLabel = UILabel()
    let tripDashboradPushButton = UIButton()
    
    override func configureHierarchy() {
        
        [introLabel, tripDashboradPushButton].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        introLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView).inset(20)
            $0.leading.equalTo(contentView)
        }
        
        tripDashboradPushButton.snp.makeConstraints {
            $0.verticalEdges.equalTo(introLabel)
            $0.width.height.equalTo(introLabel.snp.height)
            $0.trailing.equalTo(contentView)
        }
    }
    
    override func configureView() {
        
        introLabel.text = "[여행 제목] 여행을\n 진행하고 있어요"
        introLabel.textColor = .blackWhite
        introLabel.font = FontManager.getFont(size: .large, scale: .Bold)
        introLabel.numberOfLines = 2
        
        let attrString = NSMutableAttributedString(string: introLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 12
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        introLabel.attributedText = attrString

        
        let imageConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "arrow.right", withConfiguration: imageConfiguration)?.withTintColor(.justWhite, renderingMode: .alwaysOriginal)
        
        var buttonConfigure = UIButton.Configuration.plain()
        buttonConfigure.background.backgroundColor = .pointBlue
        buttonConfigure.image = image
        tripDashboradPushButton.configuration = buttonConfigure
        
        DispatchQueue.main.async {
            self.tripDashboradPushButton.layer.cornerRadius = self.tripDashboradPushButton.frame.width / 2
            self.tripDashboradPushButton.layer.masksToBounds = true
        }
    }
}
