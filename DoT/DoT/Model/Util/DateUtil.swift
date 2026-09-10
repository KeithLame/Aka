//
//  DateUtil.swift
//  DoT
//
//  Created by 이중엽 on 3/9/24.
//

import Foundation

enum DateUtil {
    
    /// from -> to 까지 하루 단위로 Date 배열로 리턴
    static func getDatesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [] }
        
        var datesRange: [Date] = [from]
        var newDate = from
        
        while newDate < to {
            newDate = Calendar.current.date(byAdding: .day, value: 1, to: newDate) ?? Date()
            
            datesRange.append(newDate)
        }
        
        return datesRange
    }
    
    /// ISO DateFormatter를 통해 Date를 String 형태로 변경
    static func getISOStringFromDate(date: Date, option: ISO8601DateFormatter.Options) -> String {
        
        let df = ISO8601DateFormatter()
        df.formatOptions = .withInternetDateTime
        df.timeZone = .autoupdatingCurrent
        let dateString = df.string(from: date)
        return dateString
    }
    
    /// Date Formatter로 입력받은 format의 String을 반환
    static func getStringFromDate(date: Date, format: String) -> String {
        
        let df = DateFormatter()
        df.dateFormat = format
        df.timeZone = .autoupdatingCurrent
        df.locale = Locale(identifier: "ko_KR")
        
        let dateString = df.string(from: date)
        return dateString
    }
    
    /// 년/월/일 00시 Date로 반환
    static func getOnlyDate(_ date: Date) -> Date {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return Calendar.current.date(from: component) ?? Date()
    }
    
    /// Date 사이의 "일" 차이를 반환
    static func getDateGap(from: Date, to: Date) -> Int {
        let fromDateOnly = DateUtil.getOnlyDate(from)
        let toDateOnly = DateUtil.getOnlyDate(to)
        
        return Calendar.current.dateComponents([.day], from: fromDateOnly, to: toDateOnly).day ?? 0
    }
    
    /// first와 second가 동일한 날짜인지 체크
    static func isSameDate(first: Date, second: Date) -> Bool {
        
        let firstDateString = self.getOnlyDate(first)
        let secondDateString = self.getOnlyDate(second)
        
        return firstDateString == secondDateString
    }
    
    /// 2024-03-14 11:15:30 +0000 포맷을 Date로 변경
    static func convertStringToDate(dateStr: String, type: DateFormatType = .basic) -> Date? {
        
        let df = DateFormatter()
        df.dateFormat = type.rawValue
        df.timeZone = .autoupdatingCurrent
        df.locale = Locale(identifier: "ko_KR")
        
        return df.date(from: dateStr)
    }
    
    /// 오늘 포함. 마지막 평일 데이터를 반환 - Format ( yyyMMdd )
    static func getLastWeekdayString() -> String {
        
        var value = 0
        var date: Date = Date()
        var isWeekend = true
        
        while isWeekend {
            date = Calendar.current.date(byAdding: .day, value: value, to: Date()) ?? Date()
            isWeekend = Calendar.current.isDateInWeekend(date)
            value -= 1
        }
        
        let result = getStringFromDate(date: date, format: "yyyyMMdd")
        
        return result
    }
    
    /// 오늘 제외. 마지막 평일 데이터를 반환 - Format ( yyyMMdd )
    static func getLastWeekdayStringExceptToday() -> String {
        
        var value = 0
        var date: Date = Date()
        var isWeekend = true
        
        while isWeekend {
            value -= 1
            date = Calendar.current.date(byAdding: .day, value: value, to: Date()) ?? Date()
            isWeekend = Calendar.current.isDateInWeekend(date)
        }
        
        let result = getStringFromDate(date: date, format: "yyyyMMdd")
        
        return result
    }
    
    /// 입력된 hour을 넘겼는지 판별
    static func isOverTimeAt(_ hour: Int) -> Bool {
        let component = Calendar.current.dateComponents([.hour], from: Date())
        
        if let curHour = component.hour {
            return curHour >= hour
        }
        
        return false
    }
}
