//
//  CalendarViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/9/24.
//

import Foundation

class CalendarViewModel {
    
    var startDate: Date? = nil
    var endDate: Date? = nil
    var rangeDate: [Date] = []
    
    // let rangeDate: Observable<[Date]> = Observable([])
    let inputSelectedListener: Observable<Date?> = Observable(nil)
    let outputSelectedListener: Observable<CalendarType?> = Observable(nil)
    
    init() {
        
        inputSelectedListener.bind { [weak self] date in
            
            guard let self else { return }
            guard let date else { return }
            
            // 1. 둘 다 있지만, endDate를 지운 경우
            if self.endDate == date {
                self.endDate = nil
                self.rangeDate = [self.startDate!]
                
                outputSelectedListener.data = .only
                return
            }
            
            // 2. 둘 다 있지만, startDate를 지운 경우
            if self.startDate == date, let endDate = self.endDate {
                self.startDate = endDate
                self.rangeDate = [endDate]
                self.endDate = nil
                
                outputSelectedListener.data = .only
                return
            }
            
            // 3. start Date만 있지만, startDate를 지운 경우 (아무것도 안남아야함)
            if self.startDate != nil, self.endDate == nil, self.startDate == date {
                self.startDate = nil
                self.endDate = nil
                self.rangeDate = []
                
                outputSelectedListener.data = .none
                return
            }
            
            // 4. start date가 없으면 start date로 설정
            guard let startDate = self.startDate else {
                self.startDate = date
                self.rangeDate = [date]
                
                outputSelectedListener.data = .only
                return
            }
            
            // 5. start date보다 늦으면 end date로 설정
            if date.timeIntervalSince(startDate) > 0 {
                self.endDate = date
                self.rangeDate = DateUtil.datesRange(from: startDate, to: date)
                
                outputSelectedListener.data = .both
            } else { // 6. start date보다 빠르면 새로운 값을 start date로 설정
                self.endDate = nil
                self.startDate = date
                self.rangeDate = [date]
                
                outputSelectedListener.data = .only
            }
        }
    }
}
