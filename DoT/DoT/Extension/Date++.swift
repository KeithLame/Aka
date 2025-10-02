//
//  Date++.swift
//  DoT
//
//  Created by 이중엽 on 3/12/24.
//

import Foundation

extension Date {
    var onlyDate: Date {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: component) ?? Date()
    }
}
