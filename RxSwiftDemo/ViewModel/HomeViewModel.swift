//
//  HomeViewModel.swift
//  RxSwiftDemo
//
//  Created by 張帥 on 2018/12/11.
//  Copyright © 2018 張帥. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    private lazy var newRepositoriesParams = BehaviorRelay(value: RepositoriesParams())
    
    private lazy var moreRepositoriesParams = BehaviorRelay(value: RepositoriesParams(page: 2))
    
    lazy var favourites = BehaviorRelay(value: [Repository]())
    
    lazy var newData:Observable<Repositories> = newRepositoriesParams
        .skip(2)
        .flatMapLatest {
            NetworkService.shared.searchRepositories($0)
        }
        .map({
            [weak self] in guard let `self` = self else { return $0 }
            return self.synchronizeSubscription($0)
        })
        .share(replay: 1)
    
    lazy var moreData:Observable<Repositories> = moreRepositoriesParams
        .skip(1)
        .map{
            [weak self] in guard let `self` = self else { return $0 }
            $0.page = self.dataSource.value.currentPage + 1
            return $0
        }
        .flatMapLatest {
            NetworkService.shared.searchRepositories($0)
        }
        .map({
            [weak self] in guard let `self` = self else { return $0 }
            return self.synchronizeSubscription($0)
        })
        .share(replay: 1)
    
    lazy var dataSource = BehaviorRelay(value: Repositories())
    
    lazy var dataSourceCount = Observable.merge(
        dataSource.filter{ $0.totalCount > 0 }.map{ "共有 \($0.totalCount) 个结果" },
        dataSource.filter{ $0.totalCount == 0 }.map{ _ in "未搜索到结果或请求太频繁请稍后再试" },
        newRepositoriesParams.filter{ $0.query.isEmpty }.map{ _ in "" },
        moreRepositoriesParams.filter{ $0.query.isEmpty }.map{ _ in "" }
    ).skip(4)
    
    func activate(_ actions: (searchAction: Observable<String>, headerAction: Observable<String>, footerAction: Observable<String>, refreshAction:Observable<Void>)) {
        Observable
            .merge(actions.searchAction, actions.headerAction)
            .map{ RepositoriesParams(query: $0) }
            .bind(to: newRepositoriesParams)
            .disposed(by: disposeBag)
        
        actions.footerAction
            .map{
                self.moreRepositoriesParams.value.query = $0
                return self.moreRepositoriesParams.value
            }
            .bind(to: moreRepositoriesParams)
            .disposed(by: disposeBag)
        
        newData
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
        moreData
            .map{
                [weak self] in guard let `self` = self else { return $0 }
                return self.dataSource.value + $0
            }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
        newData
            .filter{ $0.items.count > 0 }
            .subscribe(onNext: {
                [weak self] _ in guard let `self` = self else { return }
                self.dataSource.value.currentPage = 1
            })
            .disposed(by: disposeBag)
        
        moreData
            .filter{ $0.items.count > 0 }
            .subscribe(onNext: {
                [weak self] _ in guard let `self` = self else { return }
                self.dataSource.value.currentPage += 1
            })
            .disposed(by: disposeBag)
        
        DatabaseService.shared.repositories
            .bind(to: favourites)
            .disposed(by: disposeBag)
        
        actions.refreshAction
            .flatMap { [weak self] _ in
                Observable.of(self?.dataSource.value ?? Repositories())
            }
            .map({
                [weak self] in guard let `self` = self else { return $0 }
                return self.synchronizeSubscription($0)
            })
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .default))
            .observeOn(MainScheduler.instance)
            .bind(to: dataSource)
            .disposed(by: disposeBag)
    }
}

extension HomeViewModel {
    private func synchronizeSubscription(_ repositories: Repositories) -> Repositories {
        for repository in repositories.items {
            for favouriteRepository in self.favourites.value {
                repository.isSubscribed = repository.id == favouriteRepository.id
                if repository.isSubscribed { break }
            }
        }
        return repositories
    }
}

