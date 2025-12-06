//
//  DashboardViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/12/24.
//

import Foundation

class DashboardViewModel {
    
    var inProgressTripInfoData: InProgressTrip = InProgressTrip()
    var tripInfoDatas: [TripInfo] = []
    
    private let realmManager: RealmManager? = try? RealmManager()
    
    let tripInfoFetchListener: Observable<Void?> = Observable(nil)
    let tripInfoFetchCompleteListener: Observable<Void?> = Observable(nil)
    
    let createExchangeRateListener: Observable<[Exchange]> = Observable([])
    let createExchangeRateCompletionListener: Observable<Bool> = Observable(true)
    
    init() {
        
        realmManager?.realmURL()
        
        tripInfoFetchListener.bind { _ in
            
            guard let realmManager = self.realmManager else { return }
            
            let tripInfoData = realmManager.fetch(TripInfoDTO.self)
            
            self.tripInfoDatas = tripInfoData.map { $0.translate() }
            self.inProgressTripInfoData.title = self.getTitleInProgressTrip()
            
            self.tripInfoFetchCompleteListener.data = ()
        }
        
        createExchangeRateListener.bind { datas in
            
            guard let realmManager = self.realmManager else { return }
            
            // 새로운 데이터를 담기 전에 모두 삭제
            let oldDatas = realmManager.fetch(ExchangeRealmDTO.self)
            
            for oldData in oldDatas {
                do {
                    try realmManager.delete(oldData)
                } catch let error {
                    switch error {
                    case RealmError.objectDeleteFailed:
                        print("delete Error")
                    default: break
                    }
                }
            }
            
            // 새로운 데이터로 저장
            for newdata in datas {
                
                let newExchangeDTO = ExchangeRealmDTO(date: newdata.id, currencyUnit: newdata.currencyUnit, exchangeRate: newdata.exchangeRate, currencyName: newdata.currencyName)
                
                do {
                    try realmManager.create(newExchangeDTO)
                } catch let error {
                    switch error {
                    case RealmError.objectCreateFailed:
                        print("create Error")
                    default: break
                    }
                }
            }
            print("save complete")
            
            self.createExchangeRateCompletionListener.data = true
        }
    }
    
    /// 현재 진행중인 Trip Data들의 Title을 반환
    private func getTitleInProgressTrip() -> String {
        
        // 오늘과 동일한 날짜를 포함하는 여행 Info의 타이틀을 InProgressTripData에 저장
        let inProgressData = self.tripInfoDatas.filter {
            
            let rangeDate = DateUtil.getDatesRange(from: $0.startDate, to: $0.endDate)
            var result: Date? = nil
            
            rangeDate.forEach {
                
                if DateUtil.isSameDate(first: $0, second: Date()) { result = $0 }
            }
            
            
            return result != nil
        }
        var titles: [String] = []
        
        inProgressData.forEach {
            
            titles.append($0.title)
        }
        
        return titles.joined(separator: ", ")
    }
    
    func isCalledToday() -> Bool {
        
        guard let realmManager = self.realmManager else { return false }
        
        let exchangeDTODatas = realmManager.fetch(ExchangeRealmDTO.self)
        let exchangeDatas = exchangeDTODatas.map { $0.translate() }
        
        guard let exchangeData = exchangeDatas.first else { return false }
        
        guard let savedDate = DateUtil.convertStringToDate(dateStr: exchangeData.id) else { return false }
        guard let nowDate = DateUtil.convertStringToDate(dateStr: Date().description) else { return false }
        
        return DateUtil.isSameDate(first: savedDate, second: nowDate)
    }
}
