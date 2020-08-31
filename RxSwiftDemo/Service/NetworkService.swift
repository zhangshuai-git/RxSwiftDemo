//
//  NetworkService.swift
//  RxSwiftDemo
//
//  Created by 張帥 on 2018/12/10.
//  Copyright © 2018 張帥. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya
import Alamofire
import SVProgressHUD

class NetworkService {
    static let shared = NetworkService()
    private init() {
        isShowIndicator
            .asObservable()
            .subscribe(onNext: { $0 ? SVProgressHUD.show() : SVProgressHUD.dismiss() })
            .disposed(by: disposeBag)
    }
    
    let disposeBag = DisposeBag()
    
    private let indicator = ActivityIndicator()
    
    private lazy var isShowIndicator : Driver<Bool> = indicator.asDriver()
    
    private var manager: Alamofire.SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }

    private var plugins: [PluginType] {
        var plugins: [PluginType] = []
        #if DEBUG
//        plugins.append(NetworkLoggerPlugin(verbose: true))
        #endif
        return plugins
    }

    private lazy var moya = MoyaProvider<GitHubAPI>(manager: manager, plugins: plugins)
    
    func searchRepositories(_ params:RepositoriesParams) -> Observable<Repositories> {
        return moya.rx
            .request(.repositories(params.toJSON() ?? [:]))
            .trackActivity(indicator)
            .asObservable()
            .mapModel(Repositories.self)
            .catchErrorJustReturn(Repositories())
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observeOn(MainScheduler.instance)
    }
}
