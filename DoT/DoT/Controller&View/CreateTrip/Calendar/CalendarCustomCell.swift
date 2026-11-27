//
//  CalendarCustomCell.swift
//  DoT
//
//  Created by 이중엽 on 3/9/24.
//

import UIKit
import SnapKit
import FSCalendar

final class CalendarCustomCell: FSCalendarCell {
    
    private let centerCircle = UIView()
    private let leftRangeBox = UIView()
    private let rightRangeBox = UIView()
    
    override init!(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        centerCircle.isHidden = true
        leftRangeBox.isHidden = true
        rightRangeBox.isHidden = true
    }
    
    private func configureHierarchy() {
        [centerCircle, leftRangeBox, rightRangeBox].forEach { contentView.insertSubview($0, at: 0) }
    }
    
    private func configureLayout() {
        
        let width = contentView.frame.width.rounded(.toNearestOrEven)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalTo(contentView)
        }
        
        centerCircle.snp.makeConstraints {
            $0.horizontalEdges.equalTo(contentView)
            $0.height.equalTo(width)
            $0.centerY.equalTo(contentView)
        }
        
        leftRangeBox.snp.makeConstraints {
            $0.leading.equalTo(contentView)
            $0.trailing.equalTo(contentView.snp.centerX)
            $0.height.equalTo(width)
            $0.centerY.equalTo(contentView)
        }
        
        rightRangeBox.snp.makeConstraints {
            $0.trailing.equalTo(contentView)
            $0.leading.equalTo(contentView.snp.centerX)
            $0.height.equalTo(width)
            $0.centerY.equalTo(contentView)
        }
    }
    
    private func configureView() {
        
        centerCircle.backgroundColor = .justGray
        centerCircle.isHidden = true
        centerCircle.layer.masksToBounds = true
        
        leftRangeBox.backgroundColor = .justGray
        leftRangeBox.isHidden = true
        rightRangeBox.backgroundColor = .justGray
        rightRangeBox.isHidden = true
        
        DispatchQueue.main.async {
            self.centerCircle.layer.cornerRadius = self.centerCircle.frame.width / 2
        }
    }
    
    func configure(centerIsHidden: Bool, leftIsHidden: Bool, rightIsHidden: Bool) {
        
        centerCircle.isHidden = centerIsHidden
        leftRangeBox.isHidden = leftIsHidden
        rightRangeBox.isHidden = rightIsHidden
    }
}
