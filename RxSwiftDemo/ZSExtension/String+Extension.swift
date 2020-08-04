//
//  String+Extension.swift
//  RxSwiftDemo
//
//  Created by zhangshuai on 2020/08/04.
//  Copyright © 2020 張帥. All rights reserved.
//

extension Optional where Wrapped == String {
    @inline(__always) func isNilOrEmpty() -> Bool {
        return self == nil || self!.isEmpty
    }
    
    @inline(__always) func orEmpty() -> String {
        return self ?? ""
    }
}
extension String {
    @inline(__always) func isNotEmpty() -> Bool {
        return self != ""
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
