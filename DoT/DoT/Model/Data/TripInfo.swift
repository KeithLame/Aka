//
//  TripInfo.swift
//  DoT
//
//  Created by 이중엽 on 3/19/24.
//

import Foundation

struct TripInfo: Hashable {
    
    var objectID: String
    var place: String
    var title: String
    var headCount: Int
    var currency: String
    var budget: String
    var startDate: Date
    var endDate: Date
    var tripDetail: [TripDetailInfo]
}
