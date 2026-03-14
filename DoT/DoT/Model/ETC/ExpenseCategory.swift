//
//  ExpenseCategory.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import Foundation
import RealmSwift

enum ExpenseCategory: String, PersistableEnum, Hashable {
    case transport = "교통비"
    case roomCharge = "숙박비"
    case food = "식비"
    case cafe = "카페"
    case airport = "항공기"
    case taxi = "택시"
    case etc = "기타"
}
