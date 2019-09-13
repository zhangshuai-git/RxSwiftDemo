//
//  MJRefreshHeader+Rx.swift
//  RxSwiftDemo
//
//  Created by 張帥 on 2018/12/10.
//  Copyright © 2018 張帥. All rights reserved.
//

import Foundation
import class MJRefresh.MJRefreshHeader
import RxSwift
import RxCocoa

public extension Reactive where Base: MJRefreshHeader {
    
    var beginRefreshing: Binder<Void> {
        return Binder(base) { (header, _) in
            header.beginRefreshing()
        }
    }
    
    var isRefreshing: Binder<Bool> {
        return Binder(base) { header, refresh in
            refresh ? header.beginRefreshing() : header.endRefreshing()
        }
    }
}
