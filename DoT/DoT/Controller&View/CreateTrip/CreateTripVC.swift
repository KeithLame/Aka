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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bindData() {
        
        createTripVM.outputPeriodDataListener.bind { [weak self] period in
            
            self?.layoutView.periodButton.configuration?.title = period
        }
    }
    
    override func configureNavigation() {
        
        navigationItem.leftBarButtonItem = makeSymbolBarButtonItem()
        navigationItem.rightBarButtonItem = makeRightBarButtonItem(title: "새로운 여행 등록하기")
    }
    
    override func configure() {
        
        layoutView.periodButton.addTarget(self, action: #selector(periodButtonClicked), for: .touchUpInside)
    }
    
    // 새로운 여행 정보 저장(등록)
    override func rightBarButtonClicked(_ sender: UIButton) {
        
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
}
