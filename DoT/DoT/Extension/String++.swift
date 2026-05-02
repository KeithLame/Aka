//
//  String++.swift
//  DoT
//
//  Created by 이중엽 on 3/13/24.
//

import Foundation

extension String {
    
    // 첫 글자 공백 체크
    func isWhiteSpace() -> Bool {
        
        if self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return true
        }
        
        return false
    }
    
    // 입력된 문자열 Decimal 형태 및 소수점 표현으로 변경
    func convertDecimalString() -> String {
     
        if self.isWhiteSpace() { return "" }
        
        var isExistDot = self.isExistDot()
        
        // "."이 있으면 그대로 입력
        if isExistDot { return self }
        
        // "."이 없으면 Decimal을 우선 삭제
        let defaultString = self.replacingOccurrences(of: ",", with: "")
        
        // Double로 바뀌면 Decimal 적용해서 리턴
        if let double = Double(defaultString) {
            return NumberUtil.convertDecimal(double as NSNumber)
        }
        
        return "숫자를 입력해주세요."
    }
    
    func convertStringWithoutDecimal() -> String {
        
        return self.replacingOccurrences(of: ",", with: "")
    }
    
    func convertDouble() -> Double {
        
        let withoutDecimal = self.convertStringWithoutDecimal()
        guard let result = Double(withoutDecimal) else { return 0 }
        
        return result
    }
    
    func isExistDot() -> Bool {
        
        var isExistDot: Bool = false
        
        // "." 존재 여부 체크
        for char in Array(self) { if char == "." { isExistDot = true } }
        
        return isExistDot
    }
}
