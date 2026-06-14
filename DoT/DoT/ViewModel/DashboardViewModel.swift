//
//  DashboardViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/12/24.
//

import Foundation

final class DashboardViewModel {
    
    var tripInfoDatas: [TripInfo] = []
    var exchangeDatas: [ExchangeRealm] = []
    var onComingDatas: [TripInfo] = []
    var lastUpdatedDate: String = ""
    
    private let realmManager: RealmManager? = try? RealmManager()
    
    // Trip Info Fetch / Fetch Complete
    let tripInfoFetchListener: Observable<Void?> = Observable(nil)
    let tripInfoFetchCompleteListener: Observable<Void?> = Observable(nil)
    
    // Exchange Info Fectch / Fetch Complete
    let exchangeFetchListener: Observable<Void?> = Observable(nil)
    let exchangeFetchCompleteListener: Observable<Void?> = Observable(nil)
    
    // Create New Exchange Info To Realm
    let createExchangeListener: Observable<[ExchangeAPIModel]> = Observable([])
    let createExchangeCompletionListener: Observable<Void?> = Observable(nil)
    
    // Call Exchange Info API
    let callExchangeAPIListener: Observable<Void?> = Observable(nil)
    
    init() {
        
        // Realm URL 호출
        realmManager?.realmURL()
        
        // Trip Info Fetch From Realm
        tripInfoFetchListener.bind { [weak self] _ in
            
            guard let self, let realmManager else { return }
            
            let tripInfoData = realmManager.fetch(TripInfoDTO.self).map { $0.translate() }
            
            tripInfoDatas = getInProgressTrip(data: tripInfoData)
            onComingDatas = getOnComingTrip(data: tripInfoData)
            
            tripInfoFetchCompleteListener.data = ()
        }
        
        // Exchange Fetch From Realm
        exchangeFetchListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            guard let realmManager = realmManager else { return }
            
            exchangeDatas = realmManager.fetch(ExchangeRealm.self)
            
            // 마지막 업데이트 일 저장
            if let firstData = exchangeDatas.first {
                
                guard let updateDate = DateUtil.convertStringToDate(dateStr: firstData.date) else { return }
                
                lastUpdatedDate = DateUtil.getStringFromDate(date: updateDate, format: "yy년 MM월 dd일 기준")
            }
            
            exchangeFetchCompleteListener.data = ()
        }
        
        // Exchange Data Update To Realm
        createExchangeListener.bind { [weak self] datas in
            
            guard let self, let realmManager else { return }
            
            // 새로운 데이터를 담기 전에 모두 삭제
            let oldDatas = realmManager.fetch(ExchangeRealm.self)
            
            for oldData in oldDatas {
                do {
                    try realmManager.delete(oldData)
                } catch let error {
                    print(error)
                }
            }
            
            // 새로운 데이터로 저장
            for newdata in datas {
                
                let newExchange = ExchangeRealm(date: Date().description, currencyUnit: newdata.currencyUnit, exchangeRate: newdata.exchangeRate, currencyName: newdata.currencyName)
                
                do {
                    try realmManager.create(newExchange)
                } catch let error {
                    print(error)
                }
            }
            
            // Realm 데이터로 변경하여 변수에 저장
            exchangeFetchListener.data = ()
            createExchangeCompletionListener.data = ()
        }
        
        // Call Exchange Info API
        callExchangeAPIListener.bind { [weak self] _ in
            
            guard let self else { return }
            
            // 기존 데이터 Fetch
            exchangeFetchListener.data = ()
            
            // 기존 데이터가 비어있고, 11시가 지났다면, (오늘 포함 주말 판단) 환율 API 호출
            if exchangeDatas.isEmpty, DateUtil.isOverTimeAt(11) {
                callAPI(exceptToday: false)
                return
            }
            
            // 기존 데이터가 비어있고, 11시가 안지났다면, (오늘 제외 주말 판단) 환율 API 호출
            if exchangeDatas.isEmpty, !DateUtil.isOverTimeAt(11) {
                callAPI(exceptToday: true)
                return
            }
            
            // 오늘 시간이 오전 11시가 지났는지 확인하여 지나지 않았으면 기존 데이터 사용
            if DateUtil.isOverTimeAt(11) == false { return }
            
            // 금일 정보를 이미 호출해서 저장했다면 기존 데이터 그대로 사용
            if isCalledToday() { return }
            
            // 기존 데이터가 있으나, 오전 11시가 지났다면 (오늘 포함 주말 판단) 환율 API 호출
            callAPI(exceptToday: false)
        }
    }
    
    /// 현재 진행중인 Trip Data를 반환
    private func getInProgressTrip(data: [TripInfo]) -> [TripInfo] {
        
        // 오늘과 동일한 날짜를 포함하는 여행 Info의 타이틀을 InProgressTripData에 저장
        let inProgressData = data.filter {
            
            let rangeDate = DateUtil.getDatesRange(from: $0.startDate, to: $0.endDate)
            var result: Date? = nil
            
            rangeDate.forEach {
                
                if DateUtil.isSameDate(first: $0, second: Date()) { result = $0 }
            }
            
            
            return result != nil
        }
        
        return inProgressData
    }
    
    /// 예정된 Trip Data를 반환
    private func getOnComingTrip(data: [TripInfo]) -> [TripInfo] {
        
        let onComingData = data.filter {
            
            let gap = DateUtil.getDateGap(from: $0.startDate, to: Date())
            
            return gap < 0
        }
        
        return onComingData
    }
    
    /// 금일 환율 API를 호출했는지 여부
    private func isCalledToday() -> Bool {
        
        guard let realmManager = self.realmManager else { return false }
        
        let exchangeDatas = realmManager.fetch(ExchangeRealm.self)
        
        guard let exchangeData = exchangeDatas.first else { return false }
        
        guard let savedDate = DateUtil.convertStringToDate(dateStr: exchangeData.date) else { return false }
        guard let nowDate = DateUtil.convertStringToDate(dateStr: Date().description) else { return false }
        
        return DateUtil.isSameDate(first: savedDate, second: nowDate)
    }
    
    /// 환율 API 호출
    private func callAPI(exceptToday: Bool) {
        
        // 오늘 포함 가장 마지막 평일 Date(String)로 설정
        let date: String = exceptToday ? DateUtil.getLastWeekdayStringExceptToday() : DateUtil.getLastWeekdayString()
        let api = ExchangeAPI.AP01(date: date)
        
        APIManager.shared.callAPI(api: api, type: [ExchangeAPIModel].self) { [weak self] response in
            
            print("환율 API를 호출했습니다.")
            
            guard let self else { return }
            
            switch response {
            case .success(let success):
                
                // 빈 배열이 왔다면, 기존 데이터 사용
                if success.isEmpty {
                    exchangeFetchListener.data = ()
                    
                // 정상적인 데이터가 넘어오면, 새로운 데이터로 덮어씌우기
                } else {
                    createExchangeListener.data = success
                }
                
            case .failure(let failure):
                print(failure.responseCode!)
            }
        }
    }
}
