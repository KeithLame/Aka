//
//  Calendar++.swift
//  DoT
//
//  Created by 이중엽 on 3/12/24.
//

import Foundation

extension Calendar {
    func getDateGap(from: Date, to: Date) -> Int {
        let fromDateOnly = from.onlyDate
        let toDateOnly = to.onlyDate
        return self.dateComponents([.day], from: fromDateOnly, to: toDateOnly).day ?? 0
    }
}
