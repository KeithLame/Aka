//
//  TripDashboardViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import Foundation

class TripDashboardViewModel {
    
    var realmManager: RealmManager? = try? RealmManager()
    
    var tripIntro: TripIntro = TripIntro()
    var tripInfoListener: Observable<TripInfo?> = Observable(nil)
    var tripInfoUpdateListener: Observable<Void?> = Observable(nil)
    
    init() {
        
        tripInfoListener.bind { tripInfo in
            
            guard let tripInfo else { return }
            
            let title = tripInfo.title
            let startDate = tripInfo.startDate
            let endDate = tripInfo.endDate
            
            var dateText: String {
                
                let startGap = DateUtil.getDateGap(from: startDate, to: Date())
                let endGap = DateUtil.getDateGap(from: Date(), to: endDate)
                
                if startGap == 0 {
                    return "D-Day"
                } else if startGap > 0, endGap > 0 {
                    return "\(startGap)일차"
                } else if startGap < 0 {
                    return "여행까지 \(abs(startGap))일 남았습니다!"
                } else if endGap <= 0 {
                    return "DoT!"
                }
                return ""
            }
            
            self.tripIntro = TripIntro(title: title, preriod: dateText)
        }
        
        tripInfoUpdateListener.bind { [weak self] _ in
            
            guard let self, let realmManager, let tripInfo = tripInfoListener.data else { return }
            
            let tripInfoDatas = realmManager.fetch(TripInfo.self)
            
            for newTripInfo in tripInfoDatas {
                if newTripInfo.objectID == tripInfo.objectID {
                    tripInfoListener.data = newTripInfo
                }
            }
        }
    }
    
    func getRemainBudgetByObjectID(_ id: String) -> Double {
        
        guard let tripInfoData = tripInfoListener.data else { return 0 }
        let tripDetail = tripInfoData.tripDetail
        
        var budget = tripInfoData.budget.convertDouble()
        
        for data in tripDetail {
            
            budget -= data.expense
            
            if data.objectID == id { break }
        }
        
        return budget
    }
}
