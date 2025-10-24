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
    
    func callAPI<T: Decodable>(api: APIProtocol, type: T.Type) {
        
        var url = api.baseURL + api.path
        
        AF.request(url, method: api.method, parameters: api.param).responseDecodable(of: type) { response in
            
            switch response.result {
                
            case .success(let data):
                dump(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
