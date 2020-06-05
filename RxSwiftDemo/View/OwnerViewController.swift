//
//  RepositoryViewController.swift
//  RxSwiftDemo
//
//  Created by 張帥 on 2018/12/13.
//  Copyright © 2018 張帥. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OwnerViewController: BaseViewController {
    
    var dataSource = BehaviorRelay(value: RepositoryOwner())
    
    lazy var scrollerView: UIScrollView = {
        let scrollerView = UIScrollView()
        scrollerView.isScrollEnabled = false
        return scrollerView
    }()
    
    lazy var scrollerContentView = UIView()
    
    lazy var mainView = UIView()
    
    lazy var iconImg: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var detailLab: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func buildSubViews() {
        self.title = "Owner"
        view.addSubview(scrollerView)
        scrollerView.addSubview(scrollerContentView)
        scrollerContentView.addSubview(mainView)
        mainView.addSubview(iconImg)
        mainView.addSubview(titleLab)
        mainView.addSubview(detailLab)
    }
    
    override func makeConstraints() {
        scrollerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
        scrollerContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.left.greaterThanOrEqualToSuperview()
            make.bottom.right.lessThanOrEqualToSuperview()
        }
        
        iconImg.snp.makeConstraints { (make) in
            make.top.left.equalTo(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            make.right.lessThanOrEqualToSuperview().offset(-20)
            make.left.equalTo(iconImg.snp.right).offset(20)
            make.centerY.equalTo(iconImg)
        }
        
        detailLab.snp.makeConstraints { (make) in
            make.top.equalTo(iconImg.snp.bottom).offset(20)
            make.bottom.left.right.equalTo(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
    }
    
    override func bindViewModel() {
        dataSource
            .bind { [unowned self] in
                self.iconImg.sd_setImage(with: URL(string: $0.avatarUrl))
                self.titleLab.text = $0.login
                self.detailLab.text = $0.url
            }
            .disposed(by: disposeBag)
    }
}
