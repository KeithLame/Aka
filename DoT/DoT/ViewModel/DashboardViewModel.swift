//
//  DashboardViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/12/24.
//

import Foundation

class DashboardViewModel {
    
    var inProgressTripInfoData: InProgressTripData = InProgressTripData()
    var tripInfoDatas: [TripInfoRepository] = []
    
    private let realmManager: RealmManager<TripInfoRepository>? = try? RealmManager()
    
    let fetchListener: Observable<Void?> = Observable(nil)
    let fetchCompleteListener: Observable<Void?> = Observable(nil)
    
    init() {
        
        fetchListener.bind { _ in
            
            guard let realmManager = self.realmManager else { return }
            
            let tripInfoData = realmManager.fetch()
            
            self.tripInfoDatas = tripInfoData
            self.findInProgressTripData()
            
            self.fetchCompleteListener.data = ()
        }
    }
    
    private func findInProgressTripData() {
        
        let tripInfoDatas = self.tripInfoDatas
        
        // 오늘과 동일한 날짜를 포함하는 여행 Info의 타이틀을 InProgressTripData에 저장
        let inProgressData = tripInfoDatas.filter {
            
            let rangeDate = DateUtil.datesRange(from: $0.startDate, to: $0.endDate)
            var result: Date? = nil
            
            rangeDate.forEach { date in
                
                if DateUtil.isSameDate(first: date, second: Date()) {
                    result = date
                }
            }
            
            return result != nil
        }.first
        
        inProgressTripInfoData.title = inProgressData?.title ?? ""
    }
}
