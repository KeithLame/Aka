//
//  ExpenseViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/18/24.
//

import Foundation

class ExpenseViewModel {
    
    var tripInfoData: TripInfo? = nil
    var category: ExpenseCategory? = nil
    var expense: Double = 0
    
    var complete: (() -> Void)? = nil
    
    let realmManager = try? RealmManager()
    
    let inputCategoryButtonClickedListener: Observable<ExpenseCategory> = Observable(.transport)
    let outputCategoryButtonClickedListener: Observable<Void?> = Observable(nil)
    
    let inputNumberPadListener: Observable<(input: String, text: String)> = Observable(("", ""))
    let ouputNumberPadListener: Observable<String> = Observable("")
    
    let inputSaveButtonClickedListener: Observable<Void?> = Observable(nil)
    let outputSaveButtonClickedListener: Observable<Void?> = Observable(nil)
    
    init() {
        
        inputNumberPadListener.bind { [weak self] data in
            
            guard let self else { return }
            
            var (input, text) = data
            
            if input == "X", text.count == 1  {
                self.ouputNumberPadListener.data = "0"
                return
            }
            
            if input == "X", !text.isEmpty {
                text.removeLast()
                self.ouputNumberPadListener.data = text.convertDecimalString()
                return
            }
            
            if input == ".", text.isExistDot() {
                return
            }
            
            
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
        
        inputCategoryButtonClickedListener.bind { [weak self] data in
            
            guard let self else { return }
            
            self.category = data
            
            outputCategoryButtonClickedListener.data = ()
        }
        
        inputSaveButtonClickedListener.bind { [weak self] _ in
            
            guard let self, let realmManager, let tripInfoData, let category else { return }
            
            let newExpense = TripDetailInfo(expense: expense, category: category, photo: nil, memo: nil, expenseDate: Date())
            
            let tripInfo = realmManager.fetchOrigin(TripInfo.self)
            
            for data in tripInfo {
                if data.objectID == tripInfoData.objectID {
                    realmManager.appendTripDetail(data, tripDetail: newExpense)
                    break
                }
            }
            
            outputSaveButtonClickedListener.data = ()
        }
    }
}
