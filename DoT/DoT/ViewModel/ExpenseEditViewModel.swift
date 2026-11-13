//
//  ExpenseEditViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/21/24.
//

import Foundation

class ExpenseEditViewModel {
    
    private let realmManager = try? RealmManager()
    
    var photoIDs: [String] = []
    var expense: String = ""
    var category: ExpenseCategory? = nil
    var memo: String = ""
    var place: String = ""
    var photo: String = ""
    
    var complete: Observable<Void?> = Observable(nil)
    
    var inputTripDetailInfoListener: Observable<TripDetailInfo?> = Observable(nil)
    
    let inputExpenseListener: Observable<String> = Observable("")
    let inputMemoListener: Observable<String> = Observable("")
    let inputPlaceListener: Observable<String> = Observable("")
    
    // var inputImageDataListener: Observable<[Data]> = Observable([])
    // var outputImageDataListener: Observable<[Data]> = Observable([])
    
    var inputCategoryButtonClickedListener: Observable<ExpenseCategory> = Observable(.transport)
    var outputCategoryButtonClickedListener: Observable<ExpenseCategory?> = Observable(nil)
    
    let inputCheckSaveButtonEnabledListener: Observable<Void?> = Observable(nil)
    let outputCheckSaveButtonEnabledListener: Observable<Bool> = Observable(false)
    
    let inputEditButtonClickedListener: Observable<Void?> = Observable(nil)
    let outputEditButtonClickedListener: Observable<Void?> = Observable(nil)
    
    var inputDeleteButtonClickedListener: Observable<Void?> = Observable(nil)
    var outputDeleteButtonClickedListener: Observable<Void?> = Observable(nil)
    
    init() {
        
        // 초기 설정
        inputTripDetailInfoListener.bind { [weak self] tripDetailInfo in
            
            guard let self, let tripDetailInfo else { return }
            
            inputExpenseListener.data = NumberUtil.convertDecimal(tripDetailInfo.expense as NSNumber)
            inputMemoListener.data = tripDetailInfo.memo ?? ""
            inputPlaceListener.data = tripDetailInfo.place ?? ""
        }
        
        // expense 저장
        inputExpenseListener.bind { [weak self] expense in
            
            guard let self else { return }
            
            self.expense = expense
        }
        
        // memo 저장
        inputMemoListener.bind { [weak self] memo in
            
            guard let self else { return }
            
            self.memo = memo
        }
        
        // place 저장
        inputPlaceListener.bind { [weak self] place in
            
            guard let self else { return }
            
            self.place = place
        }
        
        // 카테고리 저장
        inputCategoryButtonClickedListener.bind { [weak self] category in
            
            guard let self else { return }
            
            self.category = category
            
            outputCategoryButtonClickedListener.data = category
            inputCheckSaveButtonEnabledListener.data = ()
        }
        
        // 수정 버튼 활성화 가능 여부 체크
        inputCheckSaveButtonEnabledListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            var result = true
            
            if expense.isEmpty || expense == "" { result = false }
            if category == nil { result = false }
            
            outputCheckSaveButtonEnabledListener.data = result
        }
        
        // 수정 버튼 클릭
        inputEditButtonClickedListener.bind { [weak self] _ in
            
            guard let self, let realmManager, let category, var tripDetail = inputTripDetailInfoListener.data else { return }
            
            tripDetail.expense = expense.convertDouble()
            tripDetail.category = category
            tripDetail.memo = memo
            tripDetail.place = place
            
            realmManager.updateTripDetailByID(id: tripDetail.objectID, value: tripDetail)
            
            outputEditButtonClickedListener.data = ()
        }
        
        // 삭제 버튼 클릭
        inputDeleteButtonClickedListener.bind { [weak self] _ in
            
            guard let self, var tripDetail = inputTripDetailInfoListener.data, let realmManager else { return }
            
            let TripDetailInfoDTO = realmManager.fetch(TripDetailInfoDTO.self)
            
            TripDetailInfoDTO.forEach {
                
                if $0.objectID == tripDetail.objectID {
                    do {
                        try realmManager.delete($0)
                    } catch {
                        print(error)
                    }
                }
            }
            
            outputDeleteButtonClickedListener.data = ()
        }
        
        // inputImageDataListener.bind { [weak self] datas in
        //
        //     guard let self else { return }
        //
        //     outputImageDataListener.data = datas
        // }
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
