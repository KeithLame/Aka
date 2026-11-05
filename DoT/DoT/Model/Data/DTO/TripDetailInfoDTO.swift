//
//  TripDetailInfo.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import Foundation
import RealmSwift

final class TripDetailInfoDTO: Object {
    @Persisted(primaryKey: true) var objectID: String = UUID().uuidString
    @Persisted var expense: Double
    @Persisted var category: ExpenseCategory
    @Persisted var photo: String?
    @Persisted var memo: String?
    @Persisted var place: String?
    @Persisted var expenseDate: Date
    @Persisted(originProperty: "tripDetail") var tripInfo: LinkingObjects<TripInfoDTO>
    
    convenience init(expense: Double, category: ExpenseCategory, photo: String?, memo: String?, place: String?, expenseDate: Date) {
        self.init()
        
        self.expense = expense
        self.category = category
        self.photo = photo
        self.memo = memo
        self.place = place
        self.expenseDate = expenseDate
    }
    
    func translate() -> TripDetailInfo {
        
        let translateTripDetailInfo = TripDetailInfo(objectID: self.objectID, place: self.place ,expense: self.expense, category: self.category, memo: self.memo , expenseDate: self.expenseDate)
        
        return translateTripDetailInfo
    }
}
