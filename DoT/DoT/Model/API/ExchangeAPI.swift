//
//  ExchangeAPI.swift
//  DoT
//
//  Created by 이중엽 on 3/14/24.
//

import Foundation
import Alamofire

enum ExchangeAPI: APIProtocol {
    
    /// date 예시) 20150101
    case AP01(date: String?)
    
    var baseURL: String {
        switch self {
        case .AP01:
            return "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON"
        }
    }
    
    var path: String {
        return ""
    }
    
    var param: Alamofire.Parameters {
        switch self {
        case .AP01(let date):
            return ["authkey": APIKey.exchagneAuth, "searchdate": date ?? "", "data": "AP01"]
        }
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
}
