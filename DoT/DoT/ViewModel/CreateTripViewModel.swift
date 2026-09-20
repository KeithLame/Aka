//
//  CreateTripViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/10/24.
//

import Foundation

final class CreateTripViewModel {
    
    private let realmManager: RealmManager? = try? RealmManager()
    
    private var title: String = ""
    private var place: String = ""
    private var budget: String = ""
    private var startDate: Date? = nil
    private var endDate: Date? = nil
    private var currency: String = "한국 원"
    private var headCount: Int = 0
    
    var dismissCallBack: (() -> Void)?
    
    let inputTitleListener: Observable<String> = Observable("")
    let inputPlaceListener: Observable<String> = Observable("")
    let inputBudgetListener: Observable<String> = Observable("")
    let inputHeadCountListener: Observable<Int?> = Observable(nil)
    
    let inputPeriodListener: Observable<(startDate: Date, endDate: Date)?> = Observable(nil)
    let outputPeriodListener: Observable<String> = Observable("")
    
    let inputCurrecyDataListener: Observable<Consts.Currency?> = Observable(nil)
    let outputCurrencyDataListener: Observable<String> = Observable("")
    
    let inputSaveButtonClickedListener: Observable<Void?> = Observable(nil)
    let outputSaveButtonClickedListener: Observable<Bool> = Observable(false)
    
    let inputCheckSaveButtonEnabledListener: Observable<Void?> = Observable(nil)
    let outputCheckSaveButtonEnabledListener: Observable<Bool> = Observable(false)
    
    init() {
        
        // title 저장
        inputTitleListener.bind { [weak self] title in
            
            guard let self else { return }
            
            self.title = title
            inputCheckSaveButtonEnabledListener.data = ()
        }
        
        // place 저장
        inputPlaceListener.bind { [weak self] place in
            
            guard let self else { return }
            
            self.place = place
            inputCheckSaveButtonEnabledListener.data = ()
        }
        
        // budget 저장
        inputBudgetListener.bind { [weak self] budget in
            
            guard let self else { return }
            
            self.budget = budget
            inputCheckSaveButtonEnabledListener.data = ()
        }
        
        // startData, endDate 저장
        inputPeriodListener.bind { [weak self] dates in
            
            guard let self, let (startDate, endDate) = dates else { return }
            
            self.startDate = startDate
            self.endDate = endDate
            
            let formatStartDate = DateUtil.getStringFromDate(date: startDate, format: "MM월 dd일(EEEEE)")
            let formatEndDate = DateUtil.getStringFromDate(date: endDate, format: "MM월 dd일(EEEEE)")
            
            self.outputPeriodListener.data = "\(formatStartDate)   -   \(formatEndDate)"
            inputCheckSaveButtonEnabledListener.data = ()
        }
        
        // cerrency 저장
        inputCurrecyDataListener.bind { [weak self] currency in
            
            guard let self, let currency else { return }
            
            self.currency = currency.name
            self.outputCurrencyDataListener.data = currency.currency
            inputCheckSaveButtonEnabledListener.data = ()
        }
        
        // haedCount 저장
        inputHeadCountListener.bind { [weak self] count in
            
            guard let self, let count else { return }
            
            self.headCount = count
            inputCheckSaveButtonEnabledListener.data = ()
        }
        
        // save 버튼 클릭시 TripInfo object 생성하여 realm에 저장
        inputSaveButtonClickedListener.bind { [weak self] _ in
            
            guard let self, let realmManager else { return }
            realmManager.realmURL()
            
            guard let startDate = self.startDate, let endDate = self.endDate else { return }
            
            let newTrip = TripInfoDTO(title: self.title,place: self.place, headCount: self.headCount, currency: self.currency, budget: self.budget, startDate: startDate, endDate: endDate)
            
            do {
                try realmManager.create(newTrip)
            } catch let error {
                
                switch error {
                case RealmError.objectCreateFailed:
                    print("create Error")
                    outputSaveButtonClickedListener.data = false
                default: break
                }
            }
            
            outputSaveButtonClickedListener.data = true
        }
        
        // 버튼 활성화 가능 여부 체크
        inputCheckSaveButtonEnabledListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            var result: Bool = true
            
            if place == "" { result = false }
            if budget == "" { result = false }
            if startDate == nil { result = false }
            if endDate == nil { result = false }
            if currency == "" { result = false }
            if headCount == 0 { result = false }
            
            outputCheckSaveButtonEnabledListener.data = result
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
    
    deinit {
        print("CreateTripViewModel Deinit")
    }
}
