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
        
        calendarVM.outputSelectedListener.bind { [weak self] _ in
            
            guard let self, let calendarType = calendarVM.outputSelectedListener.data else { return }
            
            self.layoutView.calendar.reloadData()
            self.layoutView.saveButton.isEnabled = calendarType == .both ? true : false
        }
    }
    
    override func configureNavigation() {
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage()
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
    }
    
    override func configure() {
        
        layoutView.calendar.register(CalendarCustomCell.self, forCellReuseIdentifier: CalendarCustomCell.identifier)
        layoutView.calendar.delegate = self
        layoutView.calendar.dataSource = self
        
        layoutView.saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        
        guard let calendarType = calendarVM.outputSelectedListener.data else { return }
        
        self.layoutView.saveButton.isEnabled = calendarType == .both ? true : false
    }
    
    @objc func saveButtonClicked(_ sender: UIButton) {
        
        calendarVM.saveButtonClickedListener.data = ()
        
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("CalendarViewController deinit")
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        calendar.deselect(date)
        calendarVM.inputSelectedListener.data = date
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CalendarCustomCell.identifier, for: date, at: position) as? CalendarCustomCell else { return FSCalendarCell() }
        
        
        self.calendarVM.inputDateListener.data = date
        
        let (center, left, right) = calendarVM.outputDateListener.data
        
        cell.configure(centerIsHidden: center, leftIsHidden: left, rightIsHidden: right)
        
        return cell
    }
}
