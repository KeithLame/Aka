//
//  ExpenseEditViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/21/24.
//

import Foundation

final class ExpenseEditViewModel {
    
    private let realmManager = try? RealmManager()
    
    // 데이터 임시 저장용
    private var photoIDs: [String] = []
    private var expense: String = ""
    private var category: ExpenseCategory? = nil
    private var memo: String = ""
    private var place: String = ""
    private var photo: String = ""
    
    let complete: Observable<Void?> = Observable(nil)
    
    let inputTripDetailInfoListener: Observable<TripDetailInfo?> = Observable(nil)
    let inputExpenseListener: Observable<String> = Observable("")
    let inputMemoListener: Observable<String> = Observable("")
    let inputPlaceListener: Observable<String> = Observable("")
    
    // 사진 데이터 저장
    let inputImageDataListener: Observable<[Data]> = Observable([])
    // 사진 데이터를 통해 PhotoInfoDTO로 변환 후 저장
    let outputImageDataListener: Observable<[PhotoInfoDTO]> = Observable([])
    
    let inputCategoryButtonClickedListener: Observable<ExpenseCategory> = Observable(.transport)
    let outputCategoryButtonClickedListener: Observable<ExpenseCategory?> = Observable(nil)
    
    let inputCheckSaveButtonEnabledListener: Observable<Void?> = Observable(nil)
    let outputCheckSaveButtonEnabledListener: Observable<Bool> = Observable(false)
    
    let inputEditButtonClickedListener: Observable<Void?> = Observable(nil)
    let outputEditButtonClickedListener: Observable<Void?> = Observable(nil)
    
    let inputDeleteButtonClickedListener: Observable<Void?> = Observable(nil)
    let outputDeleteButtonClickedListener: Observable<Void?> = Observable(nil)
    
    // inputImageDataListener에 Data를 새로 넣으면서 outputImageDataListener가 자동으로 호출됨
    let inputDeleteImageButtonClickedListener: Observable<Int?> = Observable(nil)
    
    init() {
        
        // 초기 설정
        inputTripDetailInfoListener.bind { [weak self] tripDetailInfo in
            
            guard let self, let tripDetailInfo else { return }
            
            inputExpenseListener.data = NumberUtil.convertDecimal(tripDetailInfo.expense as NSNumber)
            inputMemoListener.data = tripDetailInfo.memo ?? ""
            inputPlaceListener.data = tripDetailInfo.place ?? ""
            
            for photo in tripDetailInfo.photos {
                inputImageDataListener.data.append(photo.data)
            }
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
            
            guard let self,
                  let realmManager,
                  let category,
                  var tripDetail = inputTripDetailInfoListener.data,
                  let tripDetailDTO = realmManager.getTripDetailByObjectID(tripDetail.objectID) else { return }
            
            let objectID = tripDetail.objectID
            
            // 1. 기존 사진 데이터 삭제
            var photoDTOs = realmManager.fetch(PhotoInfoDTO.self)
            photoDTOs = photoDTOs.filter { $0.filename.contains(objectID) }
            
            photoDTOs.forEach {
                do {
                    try realmManager.delete($0)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            // 2. 새로운 사진 데이터 저장
            let savedPhotoDTOs = outputImageDataListener.data
            
            for photoDTO in savedPhotoDTOs {
                realmManager.appendPhoto(tripDetailDTO, photo: photoDTO)
            }
            
            // 사진 제외 정보 수정
            tripDetail.expense = expense.convertDouble()
            tripDetail.category = category
            tripDetail.memo = memo
            tripDetail.place = place
            
            realmManager.updateTripDetailByID(id: tripDetail.objectID, value: tripDetail)
            
            outputEditButtonClickedListener.data = ()
        }
        
        // 삭제 버튼 클릭 1. 하위 PhotoInfoDTO 삭제 2. TripDetailInfoDTO 삭제
        inputDeleteButtonClickedListener.bind { [weak self] _ in
            
            guard let self, let tripDetail = inputTripDetailInfoListener.data, let realmManager else { return }
            
            let objectID = tripDetail.objectID
            
            // 1. 하위 PhotoInfoDTO 삭제
            var photoDTOs = realmManager.fetch(PhotoInfoDTO.self)
            photoDTOs = photoDTOs.filter { $0.filename.contains(objectID) }
            
            photoDTOs.forEach {
                do {
                    try realmManager.delete($0)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            // 2. TripDetailInfoDTO 삭제
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
        
        // 이미지 삭제 버튼 클릭
        inputDeleteImageButtonClickedListener.bind { [weak self] tag in
            
            guard let self else { return }
            
            let dataHashVaulue = tag
            var datas = inputImageDataListener.data
            
            for idx in 0 ..< datas.count {
                if datas[idx].hashValue == dataHashVaulue {
                    datas.remove(at: idx)
                    break
                }
            }
            
            inputImageDataListener.data = datas
        }
        
        // 새로운 Data로 PhotoInfoDTO 생성 후 output에 저장
        inputImageDataListener.bind { [weak self] datas in
        
            guard let self,
                  let tripDetail = inputTripDetailInfoListener.data else { return }
            
            let objectID = tripDetail.objectID
            let imageData = inputImageDataListener.data
            var photos: [PhotoInfoDTO] = []
            
            for idx in 0 ..< imageData.count {
                let filename = objectID + "\(idx)"
                let newPhoto = PhotoInfoDTO(filename: filename, data: inputImageDataListener.data[idx])
                photos.append(newPhoto)
            }
            
            outputImageDataListener.data = photos
        }
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
