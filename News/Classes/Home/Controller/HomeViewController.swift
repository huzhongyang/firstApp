//
//  HomeViewController.swift
//  News
//
//  Created by huzhongyang on 2018/11/18.
//  Copyright © 2018 huzhongyang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    /// 标题数据表
    fileprivate let newsTitleTable = NewsTitleTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        navigationController?.navigationBar.barStyle = .black
        navigationItem.titleView = navigationBarView
        
        NetWorkTool.loadHomeNewsTitleData { (titles) in
            // 向数据库中插入数据
            self.newsTitleTable.insert(titles)
        }
    }
    
    /// 懒加载首页头部视图
    lazy var navigationBarView: HomeNavigationBarView = {
        let navigationBarView = HomeNavigationBarView.loadViewFromNib()
        return navigationBarView
    }()
}
