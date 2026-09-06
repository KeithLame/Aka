//
//  ExpenseCollectionReusableView.swift
//  DoT
//
//  Created by 이중엽 on 3/19/24.
//

import UIKit
import SnapKit

final class ExpenseCollectionReusableView: UICollectionReusableView {
    
    private let dateLabel = UILabel()
    private let accumulateLabel = UILabel()
    private let separateLineView = UIView()
    
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
        
        [dateLabel, accumulateLabel, separateLineView].forEach { addSubview($0) }
    }
    
    private func configureLayout() {
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(self).inset(30)
            $0.bottom.equalTo(self).inset(10)
            $0.leading.equalTo(self).inset(20)
        }
        
        accumulateLabel.snp.makeConstraints {
            $0.top.equalTo(self).inset(30)
            $0.bottom.equalTo(self).inset(10)
            $0.trailing.equalTo(self).inset(20)
        }
        
        separateLineView.snp.makeConstraints {
            $0.bottom.equalTo(self)
            $0.horizontalEdges.equalTo(self).inset(20)
            $0.height.equalTo(1)
        }
    }
    
    private func configureView() {
        
        dateLabel.configure(text: "날짜", fontSize: .medium, fontScale: .Bold, color: .justGray)
        accumulateLabel.configure(text: "누적금액", fontSize: .medium, fontScale: .Bold, color: .blackWhite)
        separateLineView.backgroundColor = .justGray
    }
    
    func configure(data: [TripDetailInfo], title: String) {
        
        dateLabel.text = title
        
        var accumulate: Double = 0
        
        for detail in data { accumulate += detail.expense }
        accumulateLabel.text = "- \(NumberUtil.convertDecimal(accumulate as NSNumber))"
    }
    
    deinit {
        print("ExpenseCRV deinit")
    }
}
