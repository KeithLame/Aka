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
    private var currency: String = "한국 원"
    private var headCount: Int = 0
    
    var dismissCallBack: (() -> Void)?
    
    private let realmManager: RealmManager? = try? RealmManager()
    
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
            
            self.budget = budget
        }
        
        // startData, endDate 저장
        inputPeriodDataListener.bind { dates in
            
            guard let (startDate, endDate) = dates else { return }
            
            self.startDate = startDate
            self.endDate = endDate
            
            let formatStartDate = DateUtil.getStringFromDate(date: startDate, format: "MM월 dd일(EEEEE)")
            let formatEndDate = DateUtil.getStringFromDate(date: endDate, format: "MM월 dd일(EEEEE)")
            
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
            
            let newTrip = TripInfo(title: self.title, headCount: self.headCount, currency: self.currency, budget: self.budget, startDate: startDate, endDate: endDate)
            
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
    
    /// Start Date와 EndDate 반환
    func getDates() -> (startDate: Date?, endDate: Date?) {
        
        return (startDate, endDate)
    }
    
    /// 소수점 아래 3글자로 제한
    func limitDecimalPoint(_ input: String, range: Int) -> Bool {
        
        var dotPoint: Int? = nil
        let arrText = Array(input)
        
        for idx in 0 ..< arrText.count {
            if arrText[idx] == "." {
                dotPoint = idx
            }
        }
        
        if let dotPoint {
            if range - dotPoint > 3 {
                return false
            }
        }
        
        return true
    }
}
