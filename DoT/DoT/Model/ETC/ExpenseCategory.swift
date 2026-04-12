//
//  ExpenseCategory.swift
//  DoT
//
//  Created by 이중엽 on 3/17/24.
//

import Foundation
import RealmSwift

enum ExpenseCategory: Int, PersistableEnum, Hashable {
    case transport
    case roomCharge
    case food
    case cafe
    case airport
    case taxi
    case etc
    
    var name: String {
        switch self {
        case .transport:
            return "교통비"
        case .roomCharge:
            return "숙박비"
        case .food:
            return "식비"
        case .cafe:
            return "카페"
        case .airport:
            return "항공기"
        case .taxi:
            return "택시"
        case .etc:
            return "기타"
        }
    }
}
