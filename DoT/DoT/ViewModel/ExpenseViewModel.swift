//
//  ExpenseViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/18/24.
//

import Foundation

final class ExpenseViewModel {
    
    private let realmManager = try? RealmManager()
    
    var tripInfo: TripInfo? = nil
    var category: ExpenseCategory? = nil
    
    var expense: Double = 0
    var expenseViewType: ExpenseViewType = .expense
    
    let complete: Observable<Void?> = Observable(nil)
    
    let inputAmountListener: Observable<Void?> = Observable(nil)
    let outputAmountListener: Observable<String> = Observable("")
    
    let inputCategoryButtonClickedListener: Observable<ExpenseCategory> = Observable(.transport)
    let outputCategoryButtonClickedListener: Observable<ExpenseCategory?> = Observable(nil)
    
    let inputNumberPadListener: Observable<(input: String, text: String)> = Observable(("", ""))
    let ouputNumberPadListener: Observable<String> = Observable("")
    
    let inputSaveButtonClickedListener: Observable<Void?> = Observable(nil)
    let outputSaveButtonClickedListener: Observable<Void?> = Observable(nil)
    
    let inputCheckSaveButtonEnabledListener: Observable<Void?> = Observable(nil)
    let outputCheckSaveButtonEnabledListener: Observable<Bool> = Observable(false)
    
    init() {
        
        inputAmountListener.bind { [weak self] _ in
            
            guard let self, let tripInfo else { return }
            
            switch expenseViewType {
            case .expense:
                
                outputAmountListener.data = "0"
                
            case .budgetEdit:
                
                outputAmountListener.data = tripInfo.budget
                expense = tripInfo.budget.convertDouble()
            }
        }
        
        inputNumberPadListener.bind { [weak self] data in
            
            guard let self else { return }
            
            var (input, text) = data
            
            // 지우기 및 text가 한자리라면 0으로 변경
            if input == "X", text.count == 1  {
                
                expense = 0
                ouputNumberPadListener.data = "0"
                return
            }
            
            // 지우기 및 text가 여러자리라면 마지막 글자 삭제
            if input == "X", !text.isEmpty {
                text.removeLast()
                expense = text.convertDouble()
                ouputNumberPadListener.data = text.convertDecimalString()
                return
            }
            
            // "."은 한번만 입력가능
            if input == ".", text.isExistDot() {
                return
            }
            
            // "."이하 세자리까지 입력 제한
            var dotPoint: Int? = nil
            let arrText = Array(text)
            
            for idx in 0 ..< arrText.count {
                if arrText[idx] == "." {
                    dotPoint = idx
                }
            }
            
            if let dotPoint {
                if text.count - dotPoint > 3 {
                    return
                }
            }
            
            let newOutput = text + input
            let result = newOutput.convertDecimalString()
            
            self.expense = result.convertDouble()
            self.ouputNumberPadListener.data = result
        }
        
        inputCategoryButtonClickedListener.bind { [weak self] category in
            
            guard let self else { return }
            
            self.category = category
            
            outputCategoryButtonClickedListener.data = category
            inputCheckSaveButtonEnabledListener.data = ()
        }
        
        inputSaveButtonClickedListener.bind { [weak self] _ in
            
            guard let self, let realmManager, let tripInfo else { return }
            
            switch expenseViewType {
            case .expense:
                
                guard let category else { return }
                
                let newExpense = TripDetailInfoDTO(expense: expense, category: category, photo: nil, memo: nil, place: nil, expenseDate: Date())
                
                let tripInfoDTO = realmManager.fetchOrigin(TripInfoDTO.self)
                
                for data in tripInfoDTO {
                    if data.objectID == tripInfo.objectID {
                        realmManager.appendTripDetail(data, tripDetail: newExpense)
                        break
                    }
                }
                
                complete.data = ()
                
            case .budgetEdit:
                
                let objectID = tripInfo.objectID
                let newBudget = NumberUtil.convertDecimal(expense as NSNumber)
                
                realmManager.updateTripBudgetByID(id: objectID, value: newBudget)
            }
            
            outputSaveButtonClickedListener.data = ()
        }
        
        inputCheckSaveButtonEnabledListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            var result = true
            
            switch expenseViewType {
            case .budgetEdit:
                if expense == 0 { result = false }
                
            case .expense:
                
                if expense == 0 { result = false }
                if category == nil { result = false }
            }
            
            outputCheckSaveButtonEnabledListener.data = result
        }
    }
    
    deinit {
        print("ExpenseViewModel deinit")
    }
}
