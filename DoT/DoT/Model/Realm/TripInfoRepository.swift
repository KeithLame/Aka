//
//  TripInfoRepository.swift
//  DoT
//
//  Created by 이중엽 on 3/11/24.
//

import Foundation
import RealmSwift

final class TripInfoRepository: Object {
    @Persisted(primaryKey: true) var objectID: ObjectId
    @Persisted var title: String
    @Persisted var headCount: Int
    @Persisted var currency: String
    @Persisted var budget: Double
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    
    
    convenience init(title: String, headCount: Int, currency: String, budget: Double, startDate: Date, endDate: Date) {
        self.init()
        
        self.title = title
        self.headCount = headCount
        self.currency = currency
        self.budget = budget
        self.startDate = startDate
        self.endDate = endDate
    }
}
