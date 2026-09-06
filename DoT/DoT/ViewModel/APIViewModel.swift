//
//  APIViewModel.swift
//  DoT
//
//  Created by 이중엽 on 3/14/24.
//

import Foundation

final class APIViewModel {
    
    let callExchangeAPIListener: Observable<Void?> = Observable(nil)
    let callExchangeAPICompleteListener: Observable<[ExchangeAPIModel]> = Observable([])
    
    init() {
        
        callExchangeAPIListener.bind { _ in
            
            // nil -> 오늘 날짜로 호출
            let api = ExchangeAPI.AP01(date: nil)
            
            APIManager.shared.callAPI(api: api, type: [ExchangeAPIModel].self) { response in
                
                switch response {
                case .success(let success):
                    self.callExchangeAPICompleteListener.data = success
                    
                case .failure(let failure):
                    print(failure.responseCode!)
                }
            }
        }
    }
}
