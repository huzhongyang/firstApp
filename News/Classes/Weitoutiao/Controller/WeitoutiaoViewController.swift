//
//  WeitoutiaoViewController.swift
//  News
//
//  Created by huzhongyang on 2019/2/26.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit

class WeitoutiaoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置界面
        setupUI()
    }
    
    deinit {
        // 控制器销毁，移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

extension WeitoutiaoViewController {
    /// 设置界面
    private func setupUI() {
        // 注册 日间/夜间 按钮，点击通知
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightButtonClicked), name: Notification.Name(rawValue: "dayOrNightButtonClicked"), object: nil)
        
        view.theme_backgroundColor = "colors.cellBackgroundColor"
        // 设置导航栏样式
        MyThemStyle.setupNavigationBarStyle(self, UserDefaults.standard.bool(forKey: isNight))
        // 添加导航栏右侧按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: UserDefaults.standard.bool(forKey: isNight) ? "follow_title_profile_night_18x18_" : "follow_title_profile_18x18_"), style: .plain, target: self, action: #selector(rightBarButtonClicked))
    }
    
    /// 导航栏右上角按钮点击
    @objc private func rightBarButtonClicked() {
        
    }
    
    @objc private func receiveDayOrNightButtonClicked(notification: Notification) {
        let selected = notification.object as! Bool
        MyThemStyle.setupNavigationBarStyle(self, selected)
        // 添加导航栏右侧按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: selected ? "follow_title_profile_night_18x18_" : "follow_title_profile_18x18_"), style: .plain, target: self, action: #selector(rightBarButtonClicked))
    }
}
