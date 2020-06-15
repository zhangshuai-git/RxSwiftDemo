//
//  ZSExtension.swift
//  SwiftDemo
//
//  Created by 張帥 on 2018/12/04.
//  Copyright © 2018 張帥. All rights reserved.
//

public struct ZSExtension<Target> {
    public let target: Target
    
    public init(_ target: Target) {
        self.target = target
    }
}

public protocol ZSCompatible {
    associatedtype CompatibleType
    
    static var zs: ZSExtension<CompatibleType>.Type { get set }
    
    var zs: ZSExtension<CompatibleType> { get set }
}

extension ZSCompatible {
    public static var zs: ZSExtension<Self>.Type {
        get { return ZSExtension<Self>.self }
        set { }
    }
    
    public var zs: ZSExtension<Self> {
        get { return ZSExtension(self) }
        set { }
    }
}

import class Foundation.NSObject

extension NSObject: ZSCompatible { }



protocol ScopeFunc {}
extension NSObject: ScopeFunc {}
extension Optional: ScopeFunc {}
extension ScopeFunc {
    @inline(__always) func `let`<T>(_ closure: (Self) -> T) -> T {
        return closure(self)
    }
    
    @inline(__always) func also(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

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
