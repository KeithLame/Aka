//
//  Exchange.swift
//  DoT
//
//  Created by 이중엽 on 3/19/24.
//

import Foundation

struct Exchange: Hashable {
    
    var objectID: String
    var date: String
    var currencyUnit: String
    var exchangeRate: String
    var currencyName: String
    
    init(objectID: String, date: String, currencyUnit: String, exchangeRate: String, currencyName: String) {
        self.objectID = objectID
        self.date = date
        self.currencyUnit = currencyUnit
        self.exchangeRate = exchangeRate
        self.currencyName = currencyName
    }
}
