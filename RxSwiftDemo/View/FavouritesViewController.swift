//
//  FavouritesViewController.swift
//  RxSwiftDemo
//
//  Created by 張帥 on 2019/01/11.
//  Copyright © 2019 張帥. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class FavouritesViewController: BaseViewController {
    
    lazy var dataSource = BehaviorRelay(value: [Repository]())
    
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
        return tableView
    }()
    
    override func buildSubViews() {
        self.title = "Favourites"
        view.addSubview(tableView)
    }
    
    override func makeConstraints() -> Void {
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }
    
    override func bindViewModel() {
        dataSource
            .bind(to: tableView.rx.items) { tableView, row, element in
                let cell = tableView.zs.dequeueReusableCell(HomeTableViewCell.self, for: IndexPath(row: row, section: 0))
                Observable.of(element).bind(to: cell.dataSource).disposed(by: cell.disposeBag)
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Repository.self)
            .bind { [unowned self] in self.gotoOwnerViewController(Observable.of($0.owner)) }
            .disposed(by: disposeBag)
    }
}
