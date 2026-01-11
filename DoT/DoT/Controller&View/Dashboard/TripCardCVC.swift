//
//  TripCardCollectionViewCell.swift
//  DoT
//
//  Created by 이중엽 on 3/11/24.
//

import UIKit
import SnapKit

class TripCardCollectionViewCell: BaseCollectionViewCell {
 
    let layoutView = UIView()
    let periodLabel = UILabel()
    let arrowImageView = UIImageView()
    let titleLabel = UILabel()
    let budgetLabel = UILabel()
    let remainBudgetLabel = UILabel()
    
    override func configureHierarchy() {
        
        contentView.addSubview(layoutView)
        
        [periodLabel, arrowImageView, titleLabel, budgetLabel, remainBudgetLabel].forEach {
            layoutView.insertSubview($0, at: 0)
        }
    }
    
    override func configureLayout() {
        
        layoutView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(layoutView).inset(15)
            $0.centerX.equalTo(layoutView)
        }
        
        budgetLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(layoutView).inset(10)
        }
        
        remainBudgetLabel.snp.makeConstraints {
            $0.top.equalTo(budgetLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(layoutView).inset(10)
        }
        
        periodLabel.snp.makeConstraints {
            $0.top.equalTo(remainBudgetLabel.snp.bottom).offset(30)
            $0.leading.equalTo(layoutView).inset(10)
            // $0.bottom.equalTo(layoutView).inset(15)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(periodLabel)
            $0.trailing.equalTo(layoutView).inset(10)
            $0.leading.greaterThanOrEqualTo(periodLabel.snp.trailing).offset(10)
            $0.bottom.equalTo(layoutView).inset(10)
        }
    }
    
    override func configureView() {
        
        layoutView.layer.cornerRadius = 10
        layoutView.backgroundColor = .pointBlue
        layoutView.layer.masksToBounds = true
        
        periodLabel.configure(text: "", fontSize: .small, fontScale: .Bold, color: .justWhite)
        titleLabel.configure(text: "", fontSize: .small, fontScale: .Bold, color: .justWhite)
        budgetLabel.configure(text: "", fontSize: .huge, fontScale: .Black, color: .justWhite)
        remainBudgetLabel.configure(text: "", fontSize: .small, fontScale: .Bold, color: .justWhite)
        
        let imageConfiguration = UIImage.SymbolConfiguration(font: FontManager.getFont(size: .large, scale: .Bold), scale: .large)
        arrowImageView.image = UIImage(systemName: "arrow.right")?.withTintColor(.justWhite, renderingMode: .alwaysOriginal).withConfiguration(imageConfiguration)
        arrowImageView.isUserInteractionEnabled = true
    }
    
    func configure(data: TripInfo) {
        
        guard let currency = Consts.Currency.currencyByName(name: data.currency) else { return }
        
        var dateText: String {
            
            let startGap = DateUtil.getDateGap(from: data.startDate, to: Date())
            let endGap = DateUtil.getDateGap(from: Date(), to: data.endDate)
            
            if startGap == 0 {
                return "D-Day"
            } else if startGap > 0, endGap > 0 {
                return "\(startGap)일차"
            } else if startGap < 0 {
                return "여행까지 \(abs(startGap))일 남았습니다!"
            } else if endGap <= 0 {
                return "DoT!"
            }
            return ""
        }
        
        periodLabel.text = "\(dateText)"
        titleLabel.text = data.title
        budgetLabel.text = "\(currency.currencySymbol) \(data.budget)"
        remainBudgetLabel.text = "잔고 \(data.budget)\(currency.currency)"
        
        budgetLabel.adjustsFontSizeToFitWidth = true
        remainBudgetLabel.adjustsFontSizeToFitWidth = true
        
        budgetLabel.textAlignment = .center
        remainBudgetLabel.textAlignment = .center
    }
}
