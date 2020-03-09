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



protocol LetProtocol {}

extension LetProtocol {
    func `let`(_ closure: (Self) -> Void) {
        closure(self)
    }
}

extension NSObject: LetProtocol {}
//extension Optional: LetProtocol {}

protocol AlsoProtocol {}

extension AlsoProtocol {
    func also(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: AlsoProtocol {}
//extension Optional: AlsoProtocol {}
