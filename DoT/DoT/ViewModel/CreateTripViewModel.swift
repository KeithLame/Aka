//
//  CreateTripViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/10/24.
//

import Foundation

class CreateTripViewModel {
    
    private var title: String = ""
    private var place: String = ""
    private var budget: String = ""
    private var startDate: Date? = nil
    private var endDate: Date? = nil
    private var currency: String = ""
    private var headCount: Int = 0
    
    let inputTitleDataListener: Observable<String> = Observable("")
    let inputPlaceDataListener: Observable<String> = Observable("")
    let inputBudgetDataListener: Observable<String> = Observable("")
    
    let inputPeriodDataListener: Observable<(startDate: Date, endDate: Date)?> = Observable(nil)
    let outputPeriodDataListener: Observable<String> = Observable("")
    
    let inputCurrecyDataListener: Observable<Consts.Currency?> = Observable(nil)
    let outputCurrencyDataListener: Observable<String> = Observable("")
    
    let headCountValueChangedListener: Observable<Int?> = Observable(nil)
    
    init() {
        
        // title 저장
        inputTitleDataListener.bind { title in
            
            self.title = title
        }
        
        // place 저장
        inputPlaceDataListener.bind { place in
            
            self.place = place
        }
        
        // budget 저장
        inputBudgetDataListener.bind { budget in
            
            self.budget = budget
        }
        
        // startData, endDate 저장
        inputPeriodDataListener.bind { dates in
            
            guard let (startDate, endDate) = dates else { return }
            
            self.startDate = startDate
            self.endDate = endDate
            
            let formatStartDate = DateUtil.stringFromDate(startDate)
            let formatEndDate = DateUtil.stringFromDate(endDate)
            
            self.outputPeriodDataListener.data = "\(formatStartDate)   -   \(formatEndDate)"
        }
        
        // cerrency 저장
        inputCurrecyDataListener.bind { currency in
            
            guard let currency else { return }
            
            self.outputCurrencyDataListener.data = currency.currency
            self.currency = currency.name
        }
        
        // haedCount 저장
        headCountValueChangedListener.bind { count in
            
            guard let count else { return }
            
            self.headCount = count
        }
    }
    
    func getDates() -> (startDate: Date?, endDate: Date?) {
        
        return (startDate, endDate)
    }
    
    func isWhiteSpace(title: String) -> Bool {
        
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return true
        }
        
        return false
    }
}
