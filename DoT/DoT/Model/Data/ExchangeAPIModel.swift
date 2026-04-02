//
//  ExchangeAPIModel.swift
//  DoT
//
//  Created by 이중엽 on 3/14/24.
//

import Foundation

struct ExchangeAPIModel: Decodable {
    
    let currencyUnit: String
    let exchangeRate: String
    let currencyName: String
    
    enum CodingKeys: String, CodingKey {
        case currencyUnit = "cur_unit"
        case exchangeRate = "deal_bas_r"
        case currencyName = "cur_nm"
    }
    
    func convertRealm() -> ExchangeRealm {
        
        let newExchangeRealm = ExchangeRealm(date: Date().description, currencyUnit: self.currencyUnit, exchangeRate: self.exchangeRate, currencyName: self.currencyName)
        
        return newExchangeRealm
    }
}
