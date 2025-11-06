//
//  APIManager.swift
//  DoT
//
//  Created by 이중엽 on 3/14/24.
//

import Foundation
import Alamofire

class APIManager {
    
    static let shared = APIManager()
    
    private init() { }
    
    func callAPI<T: Decodable>(api: APIProtocol, type: T.Type, completionHandler: @escaping (Result<T, AFError>) -> Void) {
        
        let url = api.baseURL + api.path
        
        AF.request(url, method: api.method, parameters: api.param).responseDecodable(of: type) { response in
            
            completionHandler(response.result)
        }
    }
}
