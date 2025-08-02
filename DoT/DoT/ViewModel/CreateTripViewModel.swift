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
    private var budget: Double = 0
    private var startDate: Date? = nil
    private var endDate: Date? = nil
    private var currency: String = "한국 원"
    private var headCount: Int = 0
    
    private let realmManager: RealmManager<TripInfoRepository>? = try? RealmManager()
    
    let inputTitleDataListener: Observable<String> = Observable("")
    let inputPlaceDataListener: Observable<String> = Observable("")
    let inputBudgetDataListener: Observable<String> = Observable("")
    let headCountValueChangedListener: Observable<Int?> = Observable(nil)
    
    let inputPeriodDataListener: Observable<(startDate: Date, endDate: Date)?> = Observable(nil)
    let outputPeriodDataListener: Observable<String> = Observable("")
    
    let inputCurrecyDataListener: Observable<Consts.Currency?> = Observable(nil)
    let outputCurrencyDataListener: Observable<String> = Observable("")
    
    let inputSaveButtonClickedListener: Observable<Void?> = Observable(nil)
    
    let outputSaveButtonClickedListener: Observable<Bool> = Observable(false)
    
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
            
            guard let budget = Double(budget) else { return }
            
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
        
        // save 버튼 클릭시 TripInfo object 생성하여 realm에 저장
        inputSaveButtonClickedListener.bind { _ in
            
            self.realmManager?.realmURL()
            
            guard let startDate = self.startDate, let endDate = self.endDate else { return }
            
            let newTrip = TripInfoRepository(title: self.title, headCount: self.headCount, currency: self.currency, budget: self.budget, startDate: startDate, endDate: endDate)
            
            do {
                try self.realmManager?.create(newTrip)
            } catch let error {
                switch error {
                case RealmError.objectCreateFailed:
                    print("create Error")
                    self.outputSaveButtonClickedListener.data = false
                default: break
                }
            }
            
            self.outputSaveButtonClickedListener.data = true
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
