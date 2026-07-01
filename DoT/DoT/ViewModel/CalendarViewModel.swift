//
//  CalendarViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/9/24.
//

import Foundation

final class CalendarViewModel {
    
    private var startDate: Date? = nil
    private var endDate: Date? = nil
    private var rangeDate: [Date] = []
    
    var complete: ((_ startDate: Date, _ endDate: Date) -> Void)? = nil
    
    let inputSelectedListener: Observable<Date?> = Observable(nil)
    let outputSelectedListener: Observable<CalendarType?> = Observable(nil)
    
    let inputDateListener: Observable<Date?> = Observable(nil)
    let outputDateListener: Observable<(Bool, Bool, Bool)> = Observable((true, true, true))
    
    let saveButtonClickedListener: Observable<Void?> = Observable(nil)
    
    let inputConfigureDataListener: Observable<(startDate: Date, endDate: Date)?> = Observable(nil)
    
    init() {
        
        // 버튼 클릭
        inputSelectedListener.bind { [weak self] date in
            
            guard let self, let date else { return }
            
            // 1. 둘 다 있지만, endDate를 지운 경우
            if self.endDate == date {
                self.endDate = nil
                self.rangeDate = [self.startDate!]
                
                self.outputSelectedListener.data = .only
                return
            }
            
            // 2. 둘 다 있지만, startDate를 지운 경우
            if self.startDate == date, let endDate = self.endDate {
                self.startDate = endDate
                self.rangeDate = [endDate]
                self.endDate = nil
                
                self.outputSelectedListener.data = .only
                return
            }
            
            // 3. start Date만 있지만, startDate를 지운 경우 (아무것도 안남아야함)
            if self.startDate != nil, self.endDate == nil, self.startDate == date {
                self.startDate = nil
                self.endDate = nil
                self.rangeDate = []
                
                self.outputSelectedListener.data = .nothing
                return
            }
            
            // 4. start date가 없으면 start date로 설정
            guard let startDate = self.startDate else {
                self.startDate = date
                self.rangeDate = [date]
                
                self.outputSelectedListener.data = .only
                return
            }
            
            // 5. start date보다 늦으면 end date로 설정
            if date.timeIntervalSince(startDate) > 0 {
                self.endDate = date
                self.rangeDate = DateUtil.getDatesRange(from: startDate, to: date)
                
                self.outputSelectedListener.data = .both
            } else { // 6. start date보다 빠르면 새로운 값을 start date로 설정
                self.endDate = nil
                self.startDate = date
                self.rangeDate = [date]
                
                self.outputSelectedListener.data = .only
            }
        }
        
        // 선택 셀 표시 방법 결정
        inputDateListener.bind { [weak self] date in
            
            guard let self, let date, let calendarType = self.outputSelectedListener.data else { return }
            
            switch calendarType {
            case .only:
                // circle만 보여주기
                if let startDate = self.startDate, startDate == date {
                    self.outputDateListener.data = (false, true, true)
                    return
                }
            case .both:
                // circle + 오른쪽
                if let startDate = self.startDate, startDate == date {
                    self.outputDateListener.data = (false, true, false)
                    return
                    // circle + 왼쪽
                } else if let endDate = self.endDate, endDate == date {
                    self.outputDateListener.data = (false, false, true)
                    return
                    // 왼쪽 + 오른쪽
                } else if self.rangeDate.contains(date) {
                    self.outputDateListener.data = (true, false, false)
                    return
                }
            case .nothing:
                // 모두 숨김
                self.outputDateListener.data = (true, true, true)
                return
            }
            
            // 모두 숨김
            self.outputDateListener.data = (true, true, true)
        }
        
        // 데이터 전달
        saveButtonClickedListener.bind { [weak self]  _ in
            
            guard let self,
                  let complete = self.complete,
                  let startDate = self.startDate,
                  let endDate = self.endDate else { return }
            
            complete(startDate, endDate)
        }
        
        inputConfigureDataListener.bind { [weak self] dates in
            
            guard let self, let (startDate, endDate) = dates else { return }
            
            let rangeDate = DateUtil.getDatesRange(from: startDate, to: endDate)
            
            self.startDate = startDate
            self.endDate = endDate
            self.rangeDate = rangeDate
            self.outputSelectedListener.data = .both
        }
    }
    
    deinit {
        print("CalendarViewModel Deinit")
    }
}
