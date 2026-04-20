//
//  TripDetailInfo.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import Foundation
import RealmSwift

final class TripDetailInfo: Object {
    @Persisted(primaryKey: true) var objectID: String = UUID().uuidString
    @Persisted var expense: Double
    @Persisted var category: ExpenseCategory
    @Persisted var photo: String?
    @Persisted var memo: String?
    @Persisted var expenseDate: Date
    
    @Persisted(originProperty: "tripDetail") var tripInfo: LinkingObjects<TripInfo>
    
    convenience init(expense: Double, category: ExpenseCategory, photo: String?, memo: String?, expenseDate: Date) {
        self.init()
        
        self.expense = expense
        self.category = category
        self.photo = photo
        self.memo = memo
        self.expenseDate = expenseDate
    }
}
