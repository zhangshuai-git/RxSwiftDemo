//
//  Rxswift+Extension.swift
//  RxSwiftDemo
//
//  Created by zhangshuai on 2020/06/09.
//  Copyright © 2020 張帥. All rights reserved.
//

import Foundation
import RxSwift

func print<T>(_ message: T, tag: String? = nil, filePath: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMdd-HHmmss"
    let date = formatter.string(from: Date())
    let fileName = (filePath as NSString).lastPathComponent
    Swift.print("\(tag ?? date) <\(fileName)> \(methodName) [Line \(lineNumber)] \(message)")
    #endif
}

extension ObservableType {
    public func debug(_ identifier: String? = nil, trimOutput: Bool = false, file: String = #file, line: UInt = #line, function: String = #function) -> Observable<E> {
        #if DEBUG
        return RxSwift.debug(identifier, trimOutput, file, line, function)
        #else
        return self.asObservable()
        #endif
    }
}


