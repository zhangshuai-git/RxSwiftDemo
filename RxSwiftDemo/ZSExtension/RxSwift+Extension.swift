//
//  Rxswift+Extension.swift
//  RxSwiftDemo
//
//  Created by zhangshuai on 2020/06/09.
//  Copyright © 2020 張帥. All rights reserved.
//

import RxSwift

extension ObservableType {
    public func print(_ identifier: String? = nil, trimOutput: Bool = false, file: String = #file, line: UInt = #line, function: String = #function) -> Observable<E> {
        #if DEBUG
        return self.debug(identifier, trimOutput: trimOutput, file: file, line: line, function: function)
        #else
        return self.asObservable()
        #endif
    }
}


