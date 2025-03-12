//
//  CalendarViewController.swift
//  DoT
//
//  Created by 이중엽 on 3/10/24.
//

import UIKit
import FSCalendar

class CalendarViewController: BaseViewController<CalendarView> {

    let calendarVM = CalendarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bindData() {
        
        calendarVM.outputSelectedListener.bind { _ in
            
            self.layoutView.calendar.reloadData()
        }
    }
    
    override func configure() {
        
        layoutView.calendar.register(CalendarCustomCell.self, forCellReuseIdentifier: CalendarCustomCell.identifier)
        layoutView.calendar.delegate = self
        layoutView.calendar.dataSource = self
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        calendar.deselect(date)
        calendarVM.inputSelectedListener.data = date
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCustomCell.identifier, for: date, at: position) as? CalendarCustomCell else { return FSCalendarCell() }
        
        let rangeDate = calendarVM.rangeDate
        
        guard let calendarType = calendarVM.outputSelectedListener.data else { return cell }
        
        layoutView.saveButton.isEnabled = calendarType == .both ? true : false
        
        switch calendarType {
        case .only:
            if let startDate = calendarVM.startDate, startDate == date {
                cell.configure(centerIsHidden: false, leftIsHidden: true, rightIsHidden: true)
            }
        case .both:
            if let startDate = calendarVM.startDate, startDate == date {
                cell.configure(centerIsHidden: false, leftIsHidden: true, rightIsHidden: false)
            } else if let endDate = calendarVM.endDate, endDate == date {
                cell.configure(centerIsHidden: false, leftIsHidden: false, rightIsHidden: true)
            } else if rangeDate.contains(date) {
                cell.configure(centerIsHidden: true, leftIsHidden: false, rightIsHidden: false)
            }
        case .nothing:
            break
        }
        
        return cell
    }
}
