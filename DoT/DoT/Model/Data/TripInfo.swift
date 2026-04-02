//
//  TripInfo.swift
//  DoT
//
//  Created by 이중엽 on 3/11/24.
//

import Foundation
import RealmSwift

final class TripInfo: Object {
    @Persisted(primaryKey: true) var objectID: String
    @Persisted var title: String
    @Persisted var headCount: Int
    @Persisted var currency: String
    @Persisted var budget: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var tripDetail: List<TripDetailInfo>
    
    
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
}
