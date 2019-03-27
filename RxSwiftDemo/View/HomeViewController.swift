//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by 張帥 on 2018/12/10.
//  Copyright © 2018 張帥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh

class HomeViewController: BaseViewController {
    
    let viewModel = HomeViewModel()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.estimatedRowHeight = 44.0
        tableView.estimatedSectionHeaderHeight = 24.0
        tableView.estimatedSectionFooterHeight = 24.0
        tableView.zs.register(HomeTableViewCell.self)
        tableView.mj_header = MJRefreshNormalHeader()
        tableView.mj_footer = MJRefreshAutoNormalFooter()
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    lazy var topView = UIView()
    
    lazy var resultLab: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var actionBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Favourites", for: .normal)
        button.setTitleColor(UIColor.mainColor, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.mainColor.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    lazy var emptyView = ZSEmptyView(message: "请输入关键字\n实时搜索GitHub上的repositories\n下拉列表刷新数据，上拉加载更多数据\n点击条目查看作者信息\n点击Subscribe收藏条目(存入数据库)")
    
    override func buildSubViews() {
        navigationItem.titleView = searchBar
        view.addSubview(topView)
        view.addSubview(tableView)
        topView.addSubview(resultLab)
        topView.addSubview(actionBtn)
    }
    
    override func makeConstraints() -> Void {
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        resultLab.snp.makeConstraints { (make) in
            make.left.equalTo(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
            make.height.equalTo(30)
            make.centerY.equalTo(actionBtn)
        }
        
        actionBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
            make.size.equalTo(CGSize(width: 80, height: 30))
            make.left.equalTo(resultLab.snp.right).offset(20)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
        }
    }
    
    override func bindViewModel() {
        viewModel.dataSourceCount
            .bind(to: resultLab.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dataSource
            .skip(2)
            .map{ $0.items }
            .bind(to: tableView.rx.items) { tableView, row, element in
                let cell = tableView.zs.dequeueReusableCell(HomeTableViewCell.self, for: IndexPath(row: row, section: 0))
                Observable.of(element).bind(to: cell.dataSource).disposed(by: cell.disposeBag)
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.dataSource
            .map { $0.totalCount == 0 }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.zs.reloadData(withEmpty: self?.emptyView)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Repository.self)
            .subscribe(onNext: {
                [weak self] in guard let `self` = self else { return }
                self.gotoOwnerViewController(Observable.of($0.owner))
            })
            .disposed(by: disposeBag)
        
        viewModel.newData
            .map{ _ in false }
            .asDriver(onErrorJustReturn: false)
            .drive(tableView.mj_header.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        Observable
            .merge(viewModel.newData.map(footerState), viewModel.moreData.map(footerState))
            .startWith(.hidden)
            .asDriver(onErrorJustReturn: .hidden)
            .drive(tableView.mj_footer.rx.refreshFooterState)
            .disposed(by: disposeBag)
        
        actionBtn.rx.tap
            .asObservable()
            .bind {
                [weak self] in guard let `self` = self else { return }
                self.gotoFavouritesViewController(self.viewModel.favourites.asObservable())
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidBeginEditing
            .asObservable()
            .bind { [weak self] in guard let `self` = self else { return }
                self.searchBar.showsCancelButton = true
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidEndEditing
            .asObservable()
            .bind { [weak self] in guard let `self` = self else { return }
                self.searchBar.showsCancelButton = false
            }
            .disposed(by: disposeBag)
        
        let searchAction: Observable<String> = searchBar.rx.text.orEmpty
            .debounce(1.0, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .share()
        
        let headerAction: Observable<String> = tableView.mj_header.rx.refreshing
            .asObservable()
            .map{ [weak self] in self?.searchBar.text ?? "" }
        
        let footerAction: Observable<String> = tableView.mj_footer.rx.refreshing
            .asObservable()
            .map{ [weak self] in self?.searchBar.text ?? "" }
        
        let refrashAction: Observable<Void> = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .asObservable()
            .map { _ in () }
        
        Observable
            .merge(searchAction.map{_ in }, searchBar.rx.cancelButtonClicked.asObservable(), tableView.rx.didScroll.asObservable())
            .bind { [weak self] _ in
                self?.searchBar.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        viewModel.activate((searchAction: searchAction, headerAction: headerAction, footerAction: footerAction, refrashAction: refrashAction))
    }
}

extension HomeViewController {
    func footerState(_ repositories: Repositories) -> RxMJRefreshFooterState {
        if repositories.items.count == 0 { return .hidden }
        print("page = \(repositories.currentPage), totalPage = \(repositories.totalPage)")
        return repositories.totalPage == 0 || repositories.currentPage < repositories.totalPage ? .default : .noMoreData
    }
}

