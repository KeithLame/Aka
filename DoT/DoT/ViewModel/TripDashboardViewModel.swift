//
//  TripDashboardViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import Foundation

class TripDashboardViewModel {
    
    var tripIntro: TripIntro = TripIntro()
    var tripInfoListener: Observable<TripInfo?> = Observable(nil)
    
    init() {
        
        tripInfoListener.bind { tripInfo in
            
            guard let tripInfo else { return }
            
            let title = tripInfo.title
            var dateText: String {
                
                let startGap = DateUtil.getDateGap(from: tripInfo.startDate, to: Date())
                let endGap = DateUtil.getDateGap(from: Date(), to: tripInfo.endDate)
                
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
    }
}
