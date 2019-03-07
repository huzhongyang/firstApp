//
//  UserDetailViewController.swift
//  News
//
//  Created by huzhongyang on 2019/1/12.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    
    var userId: Int = 0
    var userDetail: UserDetail?
    
    var userDetailDongtaiWenzhang: UserDetailDongtai?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /// 改变状态栏的字体颜色
    var changeStatusBarStyle: UIStatusBarStyle = .lightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        scrollView.delegate = self
        // 自定义 返回栏
        view.addSubview(navigationBar)
        // 返回
        navigationBar.goBackButtonClicked = { [weak self] in // 会造成循环引用
            self!.navigationController?.popViewController(animated: true)
        }
        // 设置 iPhoneX 的约束，避免 bottomView 顶到边界
        bottomViewBottom.constant = isIPhoneX ? 34 : 0
        view.layoutIfNeeded()
        
//        userId  = 51025535398
//        userId = 8
        
        /// 获取用户详情数据
        NetWorkTool.loadUserDetail(user_id: userId) { (userDetail) in
            // 获取用户详情的动态列表数据
            NetWorkTool.loadUserDetailDongtaiList(user_id: self.userId, maxCursor: 0, completionHandler: { (cursor, dongtais) in
                self.scrollView.addSubview(self.headerView)
                self.headerView.dongtais = dongtais
                self.headerView.maxCursor = cursor
                self.userDetail = userDetail
                self.headerView.userDetail = userDetail
                self.navigationBar.userDetail = userDetail
                self.headerView.currentTopTabType = .dongtai
                // 判断是否有 bottomView
                if userDetail.bottom_tab.count == 0 {
                    self.headerView.height = 979 - 34
                    self.bottomViewBottom.constant = 0
                    self.view.layoutIfNeeded()
                } else {
                    self.headerView.height = 969
                    // 赋值到 bottomView 上
                    self.bottomView.addSubview(self.myBottomView)
                    self.myBottomView.bottomTabs = userDetail.bottom_tab
                }
                self.scrollView.contentSize = CGSize(width: screenWidth, height: self.headerView.height)
            })
        }
    }
    
    /// 懒加载 自定义导航栏
    fileprivate lazy var navigationBar: NavigationBarView = {
       let navigationBar = NavigationBarView.loadViewFromNib()
        return navigationBar
    }()
    
    /// 懒加载 底部
    fileprivate lazy var myBottomView: UserDetailBottomView = {
       let myBottomView = UserDetailBottomView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        myBottomView.delegate = self
        return myBottomView
    }()
    
    /// 懒加载 头部
    fileprivate lazy var headerView: UserDetailHeaderView = {
        let headerView = UserDetailHeaderView.loadViewFromNib()
        return headerView
    }()
    
    /// 状态栏
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return changeStatusBarStyle
    }
}


extension UserDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= -44 { // 头部背景图片的拉伸
            let totalOffset = userDetailHeaderBGImageViewHeight + abs(offsetY)
            let f = totalOffset / userDetailHeaderBGImageViewHeight
            headerView.backgroundImageView.frame = CGRect(x: -screenWidth * (f - 1) * 0.5,
                                                          y: offsetY,
                                                          width: screenWidth * f,
                                                          height: totalOffset)
            navigationBar.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        } else if offsetY == 0 {
            for subview in headerView.bottomScrollView.subviews {
                let tableview = subview as! UITableView
                tableview.isScrollEnabled = false
            }
        } else {
            var alpha: CGFloat = (offsetY + 44) / 58
            alpha = min(alpha, 1.0)
            navigationBar.backgroundColor = UIColor(white: 1.0, alpha: alpha)
            if alpha == 1.0 {
                changeStatusBarStyle = .default
                navigationBar.returnButton.theme_setImage("images.personal_home_back_black_24x24_", forState: .normal)
                navigationBar.moreButton.theme_setImage("images.new_more_titlebar_24x24_", forState: .normal)
            } else {
                changeStatusBarStyle = .lightContent
                navigationBar.returnButton.theme_setImage("images.personal_home_back_white_24x24_", forState: .normal)
                navigationBar.moreButton.theme_setImage("images.new_morewhite_titlebar_22x22_", forState: .normal)
            }
            
            var alpha1: CGFloat = offsetY / 57
            if offsetY >= 43 {
                alpha1 = min(alpha1, 1.0)
                navigationBar.nameLabel.isHidden = false
                navigationBar.concernButton.isHidden = false
                navigationBar.nameLabel.textColor = UIColor(r: 0, g: 0, b: 0, alpha: alpha1)
                navigationBar.concernButton.alpha = alpha1
            } else {
                alpha1 = min(1.0, alpha1)
                navigationBar.nameLabel.textColor = UIColor(r: 0, g: 0, b: 0, alpha: alpha1)
                navigationBar.concernButton.alpha = alpha1
            }
            
            /// 设置 topTabView 滑倒顶部时, 黏住顶部
            // 14 + headerView.topTabView.frame.minY = 215
            let topViewH = CGFloat(14 + headerView.topTabView.frame.minY)
            if offsetY >= topViewH {
                headerView.y = offsetY - topViewH
                // 黏住顶部后, tableview 可以滑动
                for subview in headerView.bottomScrollView.subviews {
                    let tableview = subview as! UITableView
                    tableview.isScrollEnabled = true
                }
            } else {
                headerView.y = 0
            }
        }
    }
}

/// bottomTab 底部按钮
extension UserDetailViewController: UserDetailBottomViewDelegate {
    // bottomTab 底部按钮点击
    func bottomView(clicked button: UIButton, bottomTab: BottomTab) {
        let bottomPushVC = UserDetailBottomPushController()
        bottomPushVC.navigationItem.title = "网页浏览 "
        if bottomTab.children.count == 0 { // 直接跳转到下一个控制器
            bottomPushVC.url = bottomTab.value
            navigationController?.pushViewController(bottomPushVC, animated: true)
        } else { // 弹出 子试图
            let sb = UIStoryboard(name: "\(UserDetailBottomPopController.self)", bundle: nil)
            let popoverVC = sb.instantiateViewController(withIdentifier: "\(UserDetailBottomPopController.self)") as! UserDetailBottomPopController
            popoverVC.childrenBottom = bottomTab.children
            popoverVC.modalPresentationStyle = .custom
            popoverVC.didSelectedChild = { [weak self] in // 会造成循环引用
                bottomPushVC.url = $0.value
                self!.navigationController?.pushViewController(bottomPushVC, animated: true)
            }
            
            let popoverAnimator = PopoverAnimator()
            // 转换 frame
            let rect = myBottomView.convert(button.frame, to: view)
            let popWidth = (screenWidth - CGFloat((userDetail!.bottom_tab.count) + 1) * 20) / CGFloat((userDetail?.bottom_tab.count)!)
            let popX = CGFloat(button.tag) * (popWidth + 20) + 20
            let popHeight = CGFloat(bottomTab.children.count) * 40 + 25
            popoverAnimator.presentFrame = CGRect(x: popX, y: rect.origin.y - popHeight, width: popWidth, height: popHeight)
            popoverVC.transitioningDelegate = popoverAnimator
            present(popoverVC, animated: true, completion: nil)
        }
    }
}
