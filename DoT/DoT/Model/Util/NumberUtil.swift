//
//  NumberUtil.swift
//  DoT
//
//  Created by 이중엽 on 3/12/24.
//

import Foundation

enum NumberUtil {
    
    /// decimal 포맷으로 변경
    static func convertDecimal(_ data: NSNumber) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let result = numberFormatter.string(from: data) else { return "" }
        
        return result
    }
}
