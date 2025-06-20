//
//  CreateTripViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/10/24.
//

import Foundation

class CreateTripViewModel {
    
    private var startDate: Date? = nil
    private var endDate: Date? = nil
    
    let inputPeriodDataListener: Observable<(startDate: Date, endDate: Date)?> = Observable(nil)
    let outputPeriodDataListener: Observable<String> = Observable("")
    
    let inputCurrecyDataListener: Observable<Consts.Currency?> = Observable(nil)
    let outputCurrencyDataListener: Observable<String> = Observable("")
    
    init() {
        
        inputPeriodDataListener.bind { dates in
            
            guard let (startDate, endDate) = dates else { return }
            
            self.startDate = startDate
            self.endDate = endDate
            
            let formatStartDate = DateUtil.stringFromDate(startDate)
            let formatEndDate = DateUtil.stringFromDate(endDate)
            
            self.outputPeriodDataListener.data = "\(formatStartDate)   -   \(formatEndDate)"
        }
        
        inputCurrecyDataListener.bind { currency in
            
            guard let currency else { return }
            
            self.outputCurrencyDataListener.data = currency.currency
        }
    }
    
    func getDates() -> (startDate: Date?, endDate: Date?) {
        
        return (startDate, endDate)
    }
}
