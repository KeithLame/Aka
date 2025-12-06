//
//  ExchangeRealmDTO.swift
//  DoT
//
//  Created by 이중엽 on 3/14/24.
//

import Foundation
import RealmSwift

final class ExchangeRealmDTO: Object {
    
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var date: String
    @Persisted var currencyUnit: String
    @Persisted var exchangeRate: String
    @Persisted var currencyName: String
    
    convenience init(date: String, currencyUnit: String, exchangeRate: String, currencyName: String) {
        self.init()
        
        self.date = date
        self.currencyUnit = currencyUnit
        self.exchangeRate = exchangeRate
        self.currencyName = currencyName
    }
    
    func translate() -> Exchange {
        
        let exchange = Exchange(id: self.date, currencyUnit: self.currencyUnit, exchangeRate: self.exchangeRate, currencyName: self.currencyName)
        
        return exchange
    }
}
