//
//  Exchange.swift
//  DoT
//
//  Created by 이중엽 on 3/14/24.
//

import Foundation

struct Exchange: Hashable {
    
    let id: String = UUID().uuidString
    let currencyUnit: String
    let exchangeRate: String
    let currencyName: String
    
    init(currencyUnit: String, exchangeRate: String, currencyName: String) {
        self.currencyUnit = currencyUnit
        self.exchangeRate = exchangeRate
        self.currencyName = currencyName
    }
}
