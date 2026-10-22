//
//  ExpenseEditView.swift
//  DoT
//
//  Created by 이중엽 on 3/21/24.
//

import UIKit
import SnapKit
import TextFieldEffects

class ExpenseEditView: BaseView {
    
    let mainScrollView = UIScrollView()
    let contentView = UIView()
    let editButton = UIButton()

    let expenseLiteralLabel = UILabel()
    let expenseTextField = MadokaTextField()
    let categoryLiteralLabel = UILabel()
    let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CategoryCompositionalLayout.create())
    let memoLiteralLabel = UILabel()
    let memoTextView = UITextView()
    let placeLiteralLabel = UILabel()
    let placeTextField = MadokaTextField()
    // let photoLiteralLabel = UILabel()
    // let photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: PhotoCompositionalLayout.create())
    
    override func configureHierarchy() {
        
        [mainScrollView, editButton].forEach { addSubview($0) }
        mainScrollView.addSubview(contentView)
        
        [expenseLiteralLabel, expenseTextField, categoryLiteralLabel, categoryCollectionView, memoLiteralLabel, memoTextView, placeLiteralLabel, placeTextField].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        mainScrollView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.verticalEdges.equalTo(mainScrollView.contentLayoutGuide)
            $0.horizontalEdges.equalTo(mainScrollView.frameLayoutGuide)
        }
        
        editButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(44)
        }
        
        expenseLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).inset(40)
            $0.leading.equalTo(contentView).inset(10)
        }
        
        expenseTextField.snp.makeConstraints {
            $0.top.equalTo(expenseLiteralLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(contentView).inset(5)
        }
        
        categoryLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(expenseTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(contentView).inset(10)
        }
        
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(categoryLiteralLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(contentView)
            $0.height.equalTo(32)
        }
        
        memoLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(contentView).inset(10)
        }
        
        memoTextView.snp.makeConstraints {
            $0.top.equalTo(memoLiteralLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(contentView).inset(10)
            $0.height.equalTo(120)
        }
        
        placeLiteralLabel.snp.makeConstraints {
            $0.top.equalTo(memoTextView.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(contentView).inset(10)
        }
        
        placeTextField.snp.makeConstraints {
            $0.top.equalTo(placeLiteralLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalTo(contentView).inset(5)
            $0.bottom.greaterThanOrEqualTo(contentView).inset(100)
        }
        
        // photoLiteralLabel.snp.makeConstraints {
        //     $0.top.equalTo(placeTextField.snp.bottom).offset(30)
        //     $0.horizontalEdges.equalTo(contentView).inset(10)
        // }
        // 
        // photoCollectionView.snp.makeConstraints {
        //     $0.top.equalTo(photoLiteralLabel.snp.bottom).offset(15)
        //     $0.height.equalTo(180)
        //     $0.horizontalEdges.equalTo(contentView)
        //     $0.bottom.equalTo(contentView).inset(100)
        // }
    }
    
    override func configureView() {
        
        mainScrollView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        categoryCollectionView.backgroundColor = .clear
        // photoCollectionView.backgroundColor = .clear
        
        editButton.configure(title: "지출 수정", image: .plane)
        editButton.updateConfiguration()
        
        expenseLiteralLabel.configure(text: "지출 금액", fontSize: .large, fontScale: .Bold)
        
        expenseTextField.configure(placeHolder: "지출 금액을 입력해주세요", fontSize: .large)
        expenseTextField.placeholderColor = .justGray
        expenseTextField.font = FontManager.getFont(size: .large, scale: .Bold)
        expenseTextField.textAlignment = .left
        expenseTextField.textColor = .blackWhite
        expenseTextField.placeholderFontScale = 0.85
        expenseTextField.keyboardType = .decimalPad
        
        categoryLiteralLabel.configure(text: "카테고리", fontSize: .large, fontScale: .Bold)
        
        memoLiteralLabel.configure(text: "세부 내용", fontSize: .large, fontScale: .Bold)
        memoTextView.text = ""
        memoTextView.textColor = .blackWhite
        memoTextView.font = FontManager.getFont(size: .large, scale: .Bold)
        memoTextView.backgroundColor = .justGray.withAlphaComponent(0.1)
        memoTextView.layer.cornerRadius = 10
        
        placeLiteralLabel.configure(text: "장소", fontSize: .large, fontScale: .Bold)
        placeTextField.configure(placeHolder: "지출한 장소를 입력해주세요")
        placeTextField.placeholderColor = .justGray
        placeTextField.font = FontManager.getFont(size: .large, scale: .Bold)
        placeTextField.textAlignment = .left
        placeTextField.textColor = .blackWhite
        placeTextField.placeholderFontScale = 0.85
        
        // photoLiteralLabel.configure(text: "사진", fontSize: .large, fontScale: .Bold)
    }
    
    func configure(data: TripDetailInfo) {
        
        expenseTextField.text = "\(NumberUtil.convertDecimal(data.expense as NSNumber))"
        memoTextView.text = data.memo
        placeTextField.text = data.place
    }
}
