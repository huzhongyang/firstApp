//
//  MyNavigationController.swift
//  News
//
//  Created by huzhongyang on 2018/11/18.
//  Copyright © 2018 huzhongyang. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 首页 navigationBar 背景图片
        if UserDefaults.standard.bool(forKey: isNight) {
            navigationBar.setBackgroundImage(UIImage(named: "navigation_background_night"), for: .default)
        } else {
            navigationBar.setBackgroundImage(UIImage(named: "navigation_background"), for: .default)
        }
        
        // 监听日间/夜间按钮的点击,
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightButtonClicked), name: NSNotification.Name("dayOrNightButtonClicked"), object: nil)
        }
    
     @objc func receiveDayOrNightButtonClicked(notification: Notification) {
        let selected = notification.object as! Bool
        if selected {
            navigationBar.setBackgroundImage(UIImage(named: "navigation_background_night"), for: .default)
        } else {
            navigationBar.setBackgroundImage(UIImage(named: "navigation_background"), for: .default)
        }
        
        // 全局拖拽手势
        initGlobalPan()
    }
    
    // 拦截 push 操作
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "lefterbackicon_titlebar_24x24_"), style: .plain, target: self, action: #selector(navigationBack))
        }
        super.pushViewController(viewController, animated: true)
    }
    
    /// 返回上一控制器
    @objc private func navigationBack() {
        popViewController(animated: true)
    }
    
}

extension MyNavigationController: UIGestureRecognizerDelegate {
    /// 全局拖拽手势
    fileprivate func initGlobalPan() {
        // 创建 pan 手势
        let target = interactivePopGestureRecognizer?.delegate
        let globalPan = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        globalPan.delegate = self
        view.addGestureRecognizer(globalPan)
        // 禁止系统的手势
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count != 1
    }
}
