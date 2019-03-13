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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        if UserDefaults.standard.bool(forKey: isNight) {
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background_night"), for: .default)
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigation_background"), for: .default)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        navigationController?.navigationBar.barStyle = .black
        navigationItem.titleView = navigationBarView
        // 点击头像按钮, 跳转到 Mine 页面
        navigationBarView.didSelectedAvatarButton = { [weak self] in
            self!.navigationController?.pushViewController(MineViewController(), animated: true)
        }
        
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
