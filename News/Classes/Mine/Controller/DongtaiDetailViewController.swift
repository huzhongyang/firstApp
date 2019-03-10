//
//  DongtaiDetailViewController.swift
//  News
//
//  Created by huzhongyang on 2019/3/10.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit

class DongtaiDetailViewController: UITableViewController {
    
    var dongtai = UserDetailDongtai() {
        didSet {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置 UI
        setupUI()
    }
    
    /// 懒加自定义载导航栏头部
    private lazy var navigationBar: DongtaiDetailNavigationBar = {
       let navigationBar = DongtaiDetailNavigationBar.loadViewFromNib()
        return navigationBar
    }()
    
    deinit {
        // 控制器销毁, 移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

extension DongtaiDetailViewController {
    /// 设置界面
    private func setupUI() {
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        navigationItem.titleView = navigationBar
        // 设置导航栏样式
        MyThemStyle.setupNavigationBarStyle(self, UserDefaults.standard.bool(forKey: isNight))
        // 添加导航栏右侧按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: UserDefaults.standard.bool(forKey: isNight) ? "follow_title_profile_night_18x18_" : "follow_title_profile_18x18_"), style: .plain, target: self, action: #selector(rightBarButtonClicked))
        
        // 注册 日间/夜间 按钮，点击通知
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightButtonClicked), name: Notification.Name(rawValue: "dayOrNightButtonClicked"), object: nil)
    }
    
    /// 导航栏右上角按钮点击
    @objc private func rightBarButtonClicked() {
        
    }
    
    @objc private func receiveDayOrNightButtonClicked(notification: Notification) {
        let selected = notification.object as! Bool
        MyThemStyle.setupNavigationBarStyle(self, selected)
        // 添加导航栏右侧按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: UserDefaults.standard.bool(forKey: isNight) ? "follow_title_profile_night_18x18_" : "follow_title_profile_18x18_"), style: .plain, target: self, action: #selector(rightBarButtonClicked))
    }
}
