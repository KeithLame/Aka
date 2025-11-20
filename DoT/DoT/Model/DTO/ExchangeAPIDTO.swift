//
//  ExchangeDTO.swift
//  DoT
//
//  Created by 이중엽 on 3/14/24.
//

import Foundation

struct ExchangeAPIDTO: Decodable {
    
    let currencyUnit: String
    let exchangeRate: String
    let currencyName: String
    
    enum CodingKeys: String, CodingKey {
        case currencyUnit = "cur_unit"
        case exchangeRate = "deal_bas_r"
        case currencyName = "cur_nm"
    }
    
    func translate() -> Exchange {
        
        let exchange = Exchange(currencyUnit: self.currencyUnit, exchangeRate: self.exchangeRate, currencyName: self.currencyName)
        
        return exchange
    }
}
