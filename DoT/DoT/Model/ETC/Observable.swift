//
//  Observable.swift
//  DoT
//
//  Created by 이중엽 on 3/8/24.
//

import Foundation

final class Observable<T> {
    
    private var closure: ((T) -> Void)?
    
    var data: T {
        didSet {
            self.closure?(data)
        }
    }
    
    init(_ data: T) {
        self.data = data
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        self.closure = closure
    }
}
