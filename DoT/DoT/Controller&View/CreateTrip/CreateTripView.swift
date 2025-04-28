//
//  CreateTripView.swift
//  DoT
//
//  Created by 이중엽 on 3/9/24.
//

import UIKit
import SnapKit

class CreateTripView: BaseView {

    let titleTextField = UITextField()
    
    let placeLiteralLabel = UILabel()
    let placeTextField = UITextField()
    
    let headcountLiteralLabel = UILabel()
    let headcountLabel = UILabel()
    let headcountStepper = UIStepper()
    
    let currencyLiteralLabel = UILabel()
    let currencyChoiceButton = UIButton()
    
    let budgetLiteralLabel = UILabel()
    let budgetTextField = UITextField()
    let budgetPerPersonLabel = UILabel()
    
    let periodButton = UIButton()
    
    override func configureHierarchy() {
        
        [titleTextField, placeLiteralLabel, placeTextField, headcountLiteralLabel, headcountLabel, headcountStepper, currencyLiteralLabel, currencyChoiceButton, budgetLiteralLabel, budgetTextField, budgetPerPersonLabel, periodButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(40)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        placeLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(40)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        placeTextField.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(40)
            $0.leading.greaterThanOrEqualTo(placeLiteralLabel.snp.trailing).offset(10)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        headcountLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(placeLiteralLabel.snp.bottom).offset(40)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        headcountLabel.snp.makeConstraints {
            $0.top.equalTo(placeLiteralLabel.snp.bottom).offset(40)
            $0.leading.greaterThanOrEqualTo(headcountLiteralLabel.snp.trailing).offset(5)
        }
        
        headcountStepper.snp.makeConstraints {
            $0.centerY.equalTo(headcountLabel.snp.centerY)
            $0.leading.equalTo(headcountLabel.snp.trailing).offset(10)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        currencyLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(headcountLiteralLabel.snp.bottom).offset(40)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        currencyChoiceButton.snp.makeConstraints {
            $0.top.equalTo(headcountLiteralLabel.snp.bottom).offset(40)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        budgetLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(currencyLiteralLabel.snp.bottom).offset(40)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        budgetTextField.snp.makeConstraints {
            $0.top.equalTo(currencyLiteralLabel.snp.bottom).offset(40)
            $0.leading.greaterThanOrEqualTo(budgetLiteralLabel.snp.trailing).offset(10)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        budgetPerPersonLabel.snp.makeConstraints {
            $0.top.equalTo(budgetTextField.snp.bottom).offset(10)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        periodButton.snp.makeConstraints {
            $0.top.equalTo(budgetPerPersonLabel.snp.bottom).offset(40)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(44)
        }
    }
    
    override func configureView() {
        
        let titlePlaceHolder = "여행 제목을 입력해주세요"
        titleTextField.textAlignment = .left
        titleTextField.placeholder = titlePlaceHolder
        titleTextField.keyboardType = .default
        titleTextField.textColor = .blackWhite
        titleTextField.font = FontManager.getFont(size: .extraLarge, scale: .Medium)
        titleTextField.attributedPlaceholder = NSAttributedString(string: titlePlaceHolder, attributes: [.foregroundColor: UIColor.justGray])
        
        placeLiteralLabel.text = "여행지"
        placeLiteralLabel.textColor = .blackWhite
        placeLiteralLabel.font = FontManager.getFont(size: .regular, scale: .Bold)
        
        let placePlaceHolder = "여행지를 입력해주세요"
        placeTextField.textAlignment = .right
        placeTextField.placeholder = placePlaceHolder
        placeTextField.keyboardType = .default
        placeTextField.textColor = .blackWhite
        placeTextField.font = FontManager.getFont(size: .regular, scale: .Medium)
        placeTextField.attributedPlaceholder = NSAttributedString(string: placePlaceHolder, attributes: [.foregroundColor: UIColor.justGray])
        
        headcountLiteralLabel.text = "인원"
        headcountLiteralLabel.textColor = .blackWhite
        headcountLiteralLabel.font = FontManager.getFont(size: .regular, scale: .Bold)
        
        headcountLabel.text = "0명"
        headcountLabel.textColor = .blackWhite
        headcountLabel.font = FontManager.getFont(size: .regular, scale: .Medium)
        
        headcountStepper.maximumValue = 10
        headcountStepper.minimumValue = 0
        headcountStepper.backgroundColor = .whiteBlack
        
        currencyLiteralLabel.text = "통화"
        currencyLiteralLabel.textColor = .blackWhite
        currencyLiteralLabel.font = FontManager.getFont(size: .regular, scale: .Bold)
        
        
        currencyChoiceButton.configure(title: "통화 선택")
        
        budgetLiteralLabel.text = "예산"
        budgetLiteralLabel.textColor = .blackWhite
        budgetLiteralLabel.font = FontManager.getFont(size: .regular, scale: .Bold)
        
        let budgetPlaceHolder = "0 원"
        budgetTextField.textAlignment = .right
        budgetTextField.placeholder = budgetPlaceHolder
        budgetTextField.keyboardType = .default
        budgetTextField.textColor = .blackWhite
        budgetTextField.keyboardType = .decimalPad
        budgetTextField.font = FontManager.getFont(size: .regular, scale: .Medium)
        budgetTextField.attributedPlaceholder = NSAttributedString(string: budgetPlaceHolder, attributes: [.foregroundColor: UIColor.justGray])
        
        budgetPerPersonLabel.text = "1인당 0원"
        budgetPerPersonLabel.textColor = .blackWhite
        budgetPerPersonLabel.font = FontManager.getFont(size: .small, scale: .Medium)
        
        periodButton.configure(title: "여행 기간 설정")
    }
}
