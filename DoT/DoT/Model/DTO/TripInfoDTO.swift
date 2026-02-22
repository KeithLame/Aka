//
//  TripInfoDTO.swift
//  DoT
//
//  Created by 이중엽 on 3/11/24.
//

import Foundation
import RealmSwift

final class TripInfoDTO: Object {
    @Persisted(primaryKey: true) var objectID: String
    @Persisted var title: String
    @Persisted var headCount: Int
    @Persisted var currency: String
    @Persisted var budget: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var tripDetail: List<TripDetailInfoDTO>
    
    
    convenience init(title: String, headCount: Int, currency: String, budget: String, startDate: Date, endDate: Date) {
        self.init()
        
        self.objectID = UUID().uuidString
        self.title = title
        self.headCount = headCount
        self.currency = currency
        self.budget = budget
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func translate() -> TripInfo {
        
        let tripDetail = Array(tripDetail.map { $0.translate() })
        
        let tripInfo = TripInfo(objectID: self.objectID, title: self.title, headCount: self.headCount, currency: self.currency, budget: self.budget, startDate: self.startDate, endDate: self.endDate, tripDetail: tripDetail)
        
        return tripInfo
    }
}
