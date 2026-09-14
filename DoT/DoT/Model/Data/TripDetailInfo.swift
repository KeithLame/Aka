//
//  TripDetailInfo.swift
//  DoT
//
//  Created by 이중엽 on 3/20/24.
//

import Foundation

struct TripDetailInfo: Hashable {
    var objectID: String = UUID().uuidString
    var expense: Double
    var category: ExpenseCategory
    var photo: String?
    var memo: String?
    var expenseDate: Date
    
    init(objectID: String, expense: Double, category: ExpenseCategory, photo: String? = nil, memo: String? = nil, expenseDate: Date) {
        
        self.objectID = objectID
        self.expense = expense
        self.category = category
        self.photo = photo
        self.memo = memo
        self.expenseDate = expenseDate
    }
}
