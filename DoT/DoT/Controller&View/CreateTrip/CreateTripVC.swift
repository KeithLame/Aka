//
//  CreateTripViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/9/24.
//

import UIKit
import FSCalendar

class CreateTripViewController: BaseViewController<CreateTripView> {
    
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
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
