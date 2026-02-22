//
//  ExpenseCategory.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import Foundation
import RealmSwift

enum ExpenseCategory: String, PersistableEnum {
    case transport
    case roomCharge
    case food
    case cafe
    case airport
    case taxi
    case etc
}
