//
//  ExpenseEditViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/21/24.
//

import Foundation
import PhotosUI

class ExpenseEditViewModel {
    
    private let realmManager = try? RealmManager()
    
    var photoIDs: [String] = []
    var expense: String = ""
    var category: ExpenseCategory? = nil
    var memo: String = ""
    var place: String = ""
    var photo: String = ""
    
    // 선택한 사진의 순서에 맞게 Identifier들을 배열로 저장.
    var selectedAssetIdentifiers = [String]()
    
    var complete: Observable<Void?> = Observable(nil)
    
    var inputTripDetailInfoListener: Observable<TripDetailInfo?> = Observable(nil)
    
    let inputExpenseListener: Observable<String> = Observable("")
    let inputMemoListener: Observable<String> = Observable("")
    let inputPlaceListener: Observable<String> = Observable("")
    
    var inputImageDataListener: Observable<[Data]> = Observable([])
    var outputImageDataListener: Observable<[Data]> = Observable([])
    
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
            
            for photo in tripDetailInfo.photo {
                selectedAssetIdentifiers.append(photo.assetIdentifier)
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
            let imageData = inputImageDataListener.data
            // 사진 정보 추가 삭제
            // 1. 기존 사진 데이터 삭제
            // 1 - 1 Realm
            
            var photoDTOs = realmManager.fetch(PhotoInfoDTO.self)
            photoDTOs = photoDTOs.filter { $0.filename.contains(objectID) }
            
            photoDTOs.forEach {
                do {
                    try realmManager.delete($0)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            // 1 - 2 FileManager
            // for idx in 0 ..< imageData.count {
            //     let filename = objectID + "\(idx)"
            //     removeImageFromDocument(filename: filename)
            // }
            
            // 2. 사진 데이터 저장
            // 2 - 1 Realm
            
            for idx in 0 ..< imageData.count {
                let filename = objectID + "\(idx)"
                let newPhoto = PhotoInfoDTO(filename: filename, assetIdentifier: selectedAssetIdentifiers[idx], data: inputImageDataListener.data[idx])
                realmManager.appendPhoto(tripDetailDTO, photo: newPhoto)
            }
            
            // 2 - 2 FileManager
            // for idx in 0 ..< imageData.count {
            //     let filename = objectID + "\(idx)"
            //     saveImageToDocument(image: imageData[idx], filename: filename)
            // }
            
            // 사진 제외 정보 수정
            tripDetail.expense = expense.convertDouble()
            tripDetail.category = category
            tripDetail.memo = memo
            tripDetail.place = place
            
            realmManager.updateTripDetailByID(id: tripDetail.objectID, value: tripDetail)
            
            outputEditButtonClickedListener.data = ()
        }
        
        // 삭제 버튼 클릭
        inputDeleteButtonClickedListener.bind { [weak self] _ in
            
            guard let self, let tripDetail = inputTripDetailInfoListener.data, let realmManager else { return }
            
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
        
        inputImageDataListener.bind { [weak self] datas in
        
            guard let self else { return }
            
            outputImageDataListener.data = datas
        }
    }
    
    private func updatePhotoRealm() {
        
    }
    
    // 파일 저장
    func saveImageToDocument(image: Data, filename: String) {
        //앱 도큐먼트 위치
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        print(documentDirectory)
        
        // 이미지를 저장할 경로(파일명) 지정
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        do {
            try image.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 파일 로드
    func loadImagePathToDocument(filename: String) -> String {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return "" }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        // 해당 경로에 파일이 존재하는 지 확인
        return fileURL.path()
        // if FileManager.default.fileExists(atPath: fileURL.path()) {
        //     return UIImage(contentsOfFile: fileURL.path())
        // } else {
        //     return UIImage(systemName: "star.fill")
        // }
    }
    
    // 파일 삭제
    func removeImageFromDocument(filename: String) {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appending(path: "\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path())
            } catch {
                print(error.localizedDescription)
            }
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
