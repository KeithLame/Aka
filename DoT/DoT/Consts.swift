//
//  Consts.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import UIKit

enum Consts {
    
    enum FontSize: CGFloat {
        
        case small = 13
        case medium = 15
        case regular = 17
        case large = 19
        case extraLarge = 23
    }
    
    enum FontScale: String {
        
        case Bold = "Bold"
        case Medium = "Medium"
    }
    
    enum Currency: Int, CaseIterable {
        
        case AED, AUD, BHD, BND, CAD, CHF, CNH, DKK, EUR, GBP, HKD, IDR, JPY, KRW, KWD, MYR, NOK, NZD, SAR, SEK, SGD, THB, USD
        
        var name: String {
            switch self {
            case .AED:
                "아랍에미리트 디르함"
            case .AUD:
                "호주 달러"
            case .BHD:
                "바레인 디나르"
            case .BND:
                "브루나이 달러"
            case .CAD:
                "캐나다 달러"
            case .CHF:
                "스위스 프랑"
            case .CNH:
                "위안화"
            case .DKK:
                "덴마크 크로네"
            case .EUR:
                "유로"
            case .GBP:
                "영국 파운드"
            case .HKD:
                "홍콩 달러"
            case .IDR:
                "인도네시아 루피아"
            case .JPY:
                "일본 옌"
            case .KRW:
                "한국 원"
            case .KWD:
                "쿠웨이트 디나르"
            case .MYR:
                "말레이지아 링기트"
            case .NOK:
                "노르웨이 크로네"
            case .NZD:
                "뉴질랜드 달러"
            case .SAR:
                "사우디 리얄"
            case .SEK:
                "스웨덴 크로나"
            case .SGD:
                "싱가포르 달러"
            case .THB:
                "태국 바트"
            case .USD:
                "미국 달러"
            }
        }
        
        var currency: String {
            switch self {
            case .AED:
                "디르함"
            case .AUD:
                "달러"
            case .BHD:
                "디나르"
            case .BND:
                "달러"
            case .CAD:
                "달러"
            case .CHF:
                "프랑"
            case .CNH:
                "위안"
            case .DKK:
                "크로네"
            case .EUR:
                "유로"
            case .GBP:
                "파운드"
            case .HKD:
                "달러"
            case .IDR:
                "루피아"
            case .JPY:
                "옌"
            case .KRW:
                "원"
            case .KWD:
                "디나르"
            case .MYR:
                "링기트"
            case .NOK:
                "크로네"
            case .NZD:
                "달러"
            case .SAR:
                "리얄"
            case .SEK:
                "크로나"
            case .SGD:
                "달러"
            case .THB:
                "바트"
            case .USD:
                "달러"
            }
        }
        
        static var count: Int {
            
            return self.allCases.count
        }
    }
}
