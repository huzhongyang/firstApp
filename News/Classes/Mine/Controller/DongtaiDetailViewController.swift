//
//  DongtaiDetailViewController.swift
//  News
//
//  Created by huzhongyang on 2019/3/10.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit

class DongtaiDetailViewController: UITableViewController {
    
    /// 评论数据
    var comments = [DongtaiComment]()
    
    var dongtai = UserDetailDongtai() {
        didSet {
            navigationBar.user = dongtai.user
            headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: dongtai.detailHeaderHeight)
            headerView.dongtai = dongtai
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
    
    /// 懒加载自定义头部视图
    private lazy var headerView: DongtaiDetailHeaderView = {
        let headerView = DongtaiDetailHeaderView.loadViewFromNib()
        return headerView
    }()
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationBar.titleLabel.isHidden = (scrollView.contentOffset.y >= 50)
        navigationBar.nameButton.isHidden = (scrollView.contentOffset.y <= 50)
        navigationBar.avatarButton.isHidden = (scrollView.contentOffset.y <=  50)
        navigationBar.followersButton.isHidden = (scrollView.contentOffset.y <= 50)
        navigationBar.vImageView.isHidden = (scrollView.contentOffset.y <= 50)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
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
        
        // tableView 头部视图
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        
        // 注册 日间/夜间 按钮，点击通知
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDayOrNightButtonClicked), name: Notification.Name(rawValue: "dayOrNightButtonClicked"), object: nil)
        
        switch dongtai.item_type {
        case .commentOrQuoteOthers, .commentOrQuoteContent:
            NetWorkTool.loadUserDetailQuoteDongtaiComments(id: dongtai.id, offset: 0) { (comments) in
                self.comments = comments
                self.tableView.reloadData()
            }
        default:
            break
        }
    }
    
    /// 导航栏右上角按钮点击
    @objc private func rightBarButtonClicked() {
        
    }
    
    @objc private func receiveDayOrNightButtonClicked(notification: Notification) {
        let selected = notification.object as! Bool
        MyThemStyle.setupNavigationBarStyle(self, selected)
        // 添加导航栏右侧按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: selected ? "new_more_titlebar_night_24x24_" : "new_more_titlebar_24x24_"), style: .plain, target: self, action: #selector(rightBarButtonClicked))
    }
}
