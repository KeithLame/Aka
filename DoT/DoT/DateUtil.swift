//
//  DateUtil.swift
//  DoT
//
//  Created by 이중엽 on 3/9/24.
//

import Foundation

enum DateUtil {
    
    static func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [] }
        
        var datesRange: [Date] = [from]
        var newDate = from
        
        while newDate < to {
            newDate = Calendar.current.date(byAdding: .day, value: 1, to: newDate) ?? Date()
            
            datesRange.append(newDate)
        }
        
        return datesRange
    }
    
    static func isoDateStringFromDate(_ inputDate: Date) -> String {
        
        let df = ISO8601DateFormatter()
        df.formatOptions = .withInternetDateTime
        df.timeZone = TimeZone.current
        let dateString = df.string(from: inputDate)
        return dateString
    }
    
    static func isoDateFromString(_ inputDateString: String) -> Date? {
        
        let df = ISO8601DateFormatter()
        
        let date = df.date(from: inputDateString)
        return date
    }
}
