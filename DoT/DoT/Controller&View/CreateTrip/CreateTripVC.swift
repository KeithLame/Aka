//
//  CreateTripViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/9/24.
//

import UIKit
import FSCalendar

class CreateTripViewController: BaseViewController<CreateTripView> {
    
    var startDate: String = ""
    var endDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if !startDate.isEmpty, !endDate.isEmpty {
            
            nextVC.calendarVM.inputConfigureDataListener.data = (startDate, endDate)
        }
        
        // 한국 시간으로 넘어와서 -> isoDateString으로 변경
        nextVC.calendarVM.complete = { start, end in
            
            self.startDate = DateUtil.isoDateStringFromDate(start)
            self.endDate = DateUtil.isoDateStringFromDate(end)
        }
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
