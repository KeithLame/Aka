//
//  TripInfo.swift
//  DoT
//
//  Created by 이중엽 on 3/14/24.
//

import Foundation

struct TripInfo: Hashable {
    var objectID: String
    var title: String
    var headCount: Int
    var currency: String
    var budget: String
    var startDate: Date
    var endDate: Date
    
    
    init(objectID: String, title: String, headCount: Int, currency: String, budget: String, startDate: Date, endDate: Date) {
    
        self.objectID = objectID
        self.title = title
        self.headCount = headCount
        self.currency = currency
        self.budget = budget
        self.startDate = startDate
        self.endDate = endDate
    }
}
