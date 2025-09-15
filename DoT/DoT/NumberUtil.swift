//
//  NumberUtil.swift
//  DoT
//
//  Created by 이중엽 on 3/12/24.
//

import Foundation

enum NumberUtil {
    
    static func convertIntByCondition(_ data: Double) -> Int? {
        
        let intData = Int(data)
        let convertDouble = Double(intData)
        
        if data == convertDouble {
            return intData
        }
        
        return nil
    }
    
    static func convertDecimal(_ data: Any) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let result = numberFormatter.string(from: data as! NSNumber) else { return "" }
        
        return result
    }
}
