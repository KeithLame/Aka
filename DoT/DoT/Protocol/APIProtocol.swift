//
//  APIProtocol.swift
//  DoT
//
//  Created by 이중엽 on 3/14/24.
//

import Foundation
import Alamofire

protocol APIProtocol {
    
    var baseURL: String { get }
    var path: String { get }
    var param: Parameters { get }
    var method: HTTPMethod { get }
}
