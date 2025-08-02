//
//  CreateTripViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/9/24.
//

import UIKit
import FSCalendar

class CreateTripViewController: BaseViewController<CreateTripView> {
    
    let createTripVM = CreateTripViewModel()
    
    let realmManager = try? RealmManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("deinit CreateTrip VC")
    }
    
    override func bindData() {
        
        // 여행 기간 보여주기
        createTripVM.outputPeriodDataListener.bind { [weak self] period in
            
            self?.layoutView.periodButton.configuration?.title = period
        }
        
        // 여행 국가 통화 보여주기 및 입력된 예산 정보 리셋
        createTripVM.outputCurrencyDataListener.bind { [weak self] currency in
            
            self?.layoutView.budgetCurrencyLabel.text = currency
            self?.layoutView.budgetTextField.text = ""
        }
        
        createTripVM.outputSaveButtonClickedListener.bind { [weak self] isSuccess in
            
            guard let self else { return }
            
            isSuccess ? self.dismiss(animated: true) : print("실패!")
        }
    }
    
    override func configureNavigation() {
        
        navigationItem.leftBarButtonItem = makeSymbolBarButtonItem()
        navigationItem.rightBarButtonItem = makeRightBarButtonItem(title: "새로운 여행 등록하기")
    }
    
    override func configure() {
        
        configurePopUpButton()
        
        layoutView.periodButton.addTarget(self, action: #selector(periodButtonClicked), for: .touchUpInside)
        layoutView.titleTextField.addTarget(self, action: #selector(titleValueChanged), for: .editingChanged)
        layoutView.placeTextField.addTarget(self, action: #selector(placeValueChanged), for: .editingChanged)
        layoutView.budgetTextField.addTarget(self, action: #selector(budgetValueChanged), for: .editingChanged)
        layoutView.headcountStepper.addTarget(self, action: #selector(stepperClicked), for: .valueChanged)
    }
    
    // 새로운 여행 정보 저장(등록)
    override func rightBarButtonClicked(_ sender: UIButton) {
        
        createTripVM.inputSaveButtonClickedListener.data = ()
    }
    
    // 국가 통화 선택
    private func configurePopUpButton() {
        
        let seletedPriority = { [weak self] (action : UIAction) in
            
            guard let self else { return }
            
            guard let currency = Consts.Currency.currencyByName(name: action.title) else { return }
            
            self.createTripVM.inputCurrecyDataListener.data = currency
        }
        
        let currencyCount = Consts.Currency.count
        var menuChildren: [UIAction] = []
        
        for idx in 0 ..< currencyCount {
            
            if let currency = Consts.Currency(rawValue: idx) {
                let state: UIMenuElement.State = currency.name == "한국 원" ? .on : .off
                let action = UIAction(title: currency.name, state: state, handler: seletedPriority)
                
                menuChildren.append(action)
            }
        }
        
        layoutView.currencyChoiceButton.menu = UIMenu(children: menuChildren)
        
        layoutView.currencyChoiceButton.showsMenuAsPrimaryAction = true
        layoutView.currencyChoiceButton.changesSelectionAsPrimaryAction = true
    }
    
    // 캘린더 화면으로 이동
    @objc private func periodButtonClicked(_ sender: UIButton) {
        
        let nextVC = CalendarViewController()
        
        // 저장된 시간 정보가 있다면 Calendar VC로 전달
        let (startDate, endDate) = createTripVM.getDates()
        
        if let startDate, let endDate {
            
            nextVC.calendarVM.inputConfigureDataListener.data = (startDate, endDate)
        }
        
        // 한국 시간으로 넘어와서 -> isoDateString으로 변경 및 저장
        nextVC.calendarVM.complete = { [weak self] startDate, endDate in
            
            self?.createTripVM.inputPeriodDataListener.data = (startDate, endDate)
        }
        
        // Back Button 설정
        let backButton = UIBarButtonItem(title: "돌아가기", style: .plain, target: nil, action: nil)
        backButton.setTitleTextAttributes([.font : FontManager.getFont(size: .small, scale: .Bold)], for: .normal)
        navigationItem.backBarButtonItem = backButton
        navigationItem.backBarButtonItem?.tintColor = .blackWhite
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 제목 입력
    @objc private func titleValueChanged(_ sender: UITextField) {
        
        guard let title = sender.text else { return }
        
        if createTripVM.isWhiteSpace(title: title) {
            sender.text = ""
            return
        }
        
        createTripVM.inputTitleDataListener.data = title
    }
    
    // 장소 입력
    @objc private func placeValueChanged(_ sender: UITextField) {
        
        guard let place = sender.text else { return }
        
        if createTripVM.isWhiteSpace(title: place) {
            sender.text = ""
            return
        }
        
        createTripVM.inputPlaceDataListener.data = place
    }
    
    // 예산 입력
    @objc private func budgetValueChanged(_ sender: UITextField) {
        
        guard let budget = sender.text else { return }
        
        if createTripVM.isWhiteSpace(title: budget) {
            sender.text = ""
            return
        }
        
        createTripVM.inputBudgetDataListener.data = budget
    }
    
    // 인원 변경
    @objc private func stepperClicked(_ sender: UIStepper) {
        
        let value = Int(sender.value)
        layoutView.headcountLabel.text = "\(value)명"
        
        createTripVM.headCountValueChangedListener.data = value
    }
}
