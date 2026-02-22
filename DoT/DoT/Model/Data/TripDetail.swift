//
//  TripDetail.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import Foundation

struct TripDetail: Hashable {
    var objectID: String
    var expense: Double
    var category: ExpenseCategory
    var photo: String?
    var memo: String?
    var expenseDate: Date
    var tripInfo: TripInfo? = nil
    
    init(objectID: String, expense: Double, category: ExpenseCategory, photo: String?, memo: String?, expenseDate: Date, tripInfo: TripInfo? = nil) {
        self.objectID = objectID
        self.expense = expense
        self.category = category
        self.photo = photo
        self.memo = memo
        self.expenseDate = expenseDate
        self.tripInfo = tripInfo
    }
}
