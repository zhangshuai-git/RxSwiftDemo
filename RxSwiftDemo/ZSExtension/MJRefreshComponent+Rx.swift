//
//  MJRefreshComponent+Rx.swift
//  RxSwiftDemo
//
//  Created by 張帥 on 2018/12/10.
//  Copyright © 2018 張帥. All rights reserved.
//

import Foundation
import class MJRefresh.MJRefreshComponent
import RxSwift
import RxCocoa

public extension Reactive where Base: MJRefreshComponent {
    
    var refreshing: ControlEvent<Void> {
        let source = Observable<Void>.create {
            [weak control = self.base] observer in
            if let control = control {
                control.refreshingBlock = {
                    observer.onNext(())
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
}
