//
//  TripDashboardViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import Foundation

final class TripDashboardViewModel {
    
    private var realmManager: RealmManager? = try? RealmManager()
    
    var tripIntro: TripIntro = TripIntro()
    var tripInfo: TripInfo? = nil
    var remainBudget: Double = 0
    
    var tripInfoUpdateListener: Observable<Void?> = Observable(nil)
    var tripInfoUpdateCompleteListener: Observable<Void?> = Observable(nil)
    
    var remainBudgetByObjectIDListener: Observable<String> = Observable("")
    
    init() {
        
        tripInfoUpdateListener.bind { [weak self] _ in
            
            guard let self, let realmManager, let tripInfo else { return }
            
            let title = tripInfo.title
            let startDate = tripInfo.startDate
            let endDate = tripInfo.endDate
            
            var dateText: String {
                
                let startGap = DateUtil.getDateGap(from: startDate, to: Date())
                let endGap = DateUtil.getDateGap(from: Date(), to: endDate)
                
                if startGap == 0 {
                    return "첫째 날"
                } else if startGap > 0, endGap > 0 {
                    return "여행 \(startGap)일차"
                } else if startGap < 0 {
                    return "여행까지 \(abs(startGap))일 남았습니다!"
                } else if endGap == 0 {
                    return "마지막 날"
                } else if endGap < 0 {
                    return "종료된 여행"
                }
                return ""
            }
            
            self.tripIntro = TripIntro(title: title, preriod: dateText)
            
            let tripInfoDatas = realmManager.fetch(TripInfoDTO.self).map { $0.translate() }
            
            for newTripInfo in tripInfoDatas {
                if newTripInfo.objectID == tripInfo.objectID {
                    self.tripInfo = newTripInfo
                }
            }
            
            tripInfoUpdateCompleteListener.data = ()
        }
        
        remainBudgetByObjectIDListener.bind { [weak self] objectID in
            
            guard let self else { return }
            
            remainBudget = getRemainBudgetByObjectID(objectID)
        }
    }
    
    deinit {
        print("TripDashboardViewModel Deinit")
    }
    
    private func getRemainBudgetByObjectID(_ id: String) -> Double {
        
        guard let tripInfo else { return 0 }
        let tripDetail = tripInfo.tripDetail.sorted { $0.expenseDate < $1.expenseDate }
        
        var budget = tripInfo.budget.convertDouble()
        
        for data in tripDetail {
            
            budget -= data.expense
            
            if data.objectID == id { break }
        }
        
        return budget
    }
}
