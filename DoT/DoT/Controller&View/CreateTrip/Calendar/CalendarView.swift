//
//  CalendarView.swift
//  DoT
//
//  Created by 이중엽 on 3/10/24.
//

import UIKit
import SnapKit
import FSCalendar

final class CalendarView: BaseView {

    let calendar = FSCalendar()
    let saveButton = UIButton()
    
    override func configureHierarchy() {
        
        [calendar, saveButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        
        calendar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(44)
        }
    }
    
    override func configureView() {
        
        configureCalendar()
        
        saveButton.configure(title: "기간 선택 완료", image: nil)
        saveButton.updateConfiguration()
        saveButton.isEnabled = false
    }
    
    private func configureCalendar() {
        
        calendar.allowsMultipleSelection = true
        calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.backgroundColor = .clear
        
        calendar.today = nil
        
        calendar.appearance.eventDefaultColor = .blackWhite
        calendar.appearance.todayColor = .justGray
        
        calendar.appearance.headerTitleColor = .blackWhite
        calendar.appearance.headerTitleFont = FontManager.getFont(size: .medium, scale: .Bold)
        
        calendar.appearance.weekdayTextColor = .blackWhite
        calendar.appearance.weekdayFont = FontManager.getFont(size: .medium, scale: .Bold)
        
        calendar.appearance.titleDefaultColor = .blackWhite
        calendar.appearance.titleFont = FontManager.getFont(size: .small, scale: .Medium)
        
        calendar.appearance.headerTitleAlignment = .center
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        calendar.placeholderType = .none
    }
    
    deinit {
        print("CalendarView deinit")
    }
}
