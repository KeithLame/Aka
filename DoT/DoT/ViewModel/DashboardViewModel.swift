//
//  DashboardViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/12/24.
//

import Foundation

class DashboardViewModel {
    
    var inProgressTripInfoData: InProgressTripData = InProgressTripData()
    var tripInfoDatas: [TripInfo] = []
    
    private let realmManager: RealmManager<TripInfoDTO>? = try? RealmManager()
    
    let fetchListener: Observable<Void?> = Observable(nil)
    let fetchCompleteListener: Observable<Void?> = Observable(nil)
    
    init() {
        
        fetchListener.bind { _ in
            
            guard let realmManager = self.realmManager else { return }
            
            let tripInfoData = realmManager.fetch()
            
            self.tripInfoDatas = tripInfoData.map { $0.translate() }
            self.inProgressTripInfoData.title = self.getTitleInProgressTrip()
            
            self.fetchCompleteListener.data = ()
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
}
