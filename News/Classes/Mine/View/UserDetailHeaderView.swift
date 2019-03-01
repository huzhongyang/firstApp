//
//  UserDetailHeaderView.swift
//  News
//
//  Created by huzhongyang on 2019/1/12.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class UserDetailHeaderView: UIView, NibLoadable {
    
    /// 动态数据的数组
    var dongtais = [UserDetailDongtai]() {
        didSet {
            if bottomScrollView.subviews.count > 0 {
                let tableview = bottomScrollView.subviews[0] as! UITableView
                tableview.rowHeight = UITableView.automaticDimension
                tableview.reloadData()
            }
        }
    }
    
    var userDetail: UserDetail? {
        didSet {
            backgroundImageView.kf.setImage(with: URL(string: userDetail!.bg_img_url))
            
            avatarImageView.kf.setImage(with: URL(string: userDetail!.avatar_url))
            
            vImageView.isHidden = !userDetail!.user_verified
            
            nameLabel.text = userDetail!.screen_name
            
            if userDetail!.verified_agency == "" {
                verifiedAgencyLabelHeight.constant = 0
                verifiedAgencyLabelTop.constant = 0
            } else {
                verifiedAgencyLabel.text = userDetail!.verified_agency + "："
                verifiedContentLabel.text = userDetail!.verified_content
            }
            
            concernButton.isSelected = userDetail!.is_following
            concernButton.theme_backgroundColor = userDetail!.is_following ? "colors.userDetailFollowingConcernBtnBgColor" : "colors.userDetailConcernBtnBgColor"
            concernButton.borderColor = userDetail!.is_following ? UIColor(r: 232, g: 232, b: 232) : UIColor(r: 230, g: 100, b: 95)
            concernButton.borderWidth = userDetail!.is_following ? 1 : 0
            
            if userDetail!.area == "" {
                areaButton.isHidden = true
                areaButtonHeight.constant = 0
                areaButtonTop.constant = 0
            } else {
                areaButton.setTitle(userDetail!.area, for: .normal)
            }
            
            descriptionLabel.text = userDetail!.description as String
            if userDetail!.descriptionHeight > 21 {
                unfoldButton.isHidden = false
                unfoldButtonWidth.constant = 40.0
            }
            
            // 关注按钮 约束
            recommendButtonWidth.constant = 0
            recommendButtonTrailing.constant = 10.0
            
            followersCountLabel.text = userDetail!.followersCount
            followingsCountLabel.text = userDetail!.followingsCount
            
            // topTab
            if userDetail!.top_tab.count > 0 {
                // 添加按钮 和 tableview
                for (index, topTab) in userDetail!.top_tab.enumerated() {
                    // 按钮
                    let button = UIButton(frame: CGRect(x: CGFloat(index) * topTabButtonWidth,
                                                        y: 0,
                                                        width: topTabButtonWidth,
                                                        height: scrollView.height))
                    button.setTitle(topTab.show_name, for: .normal)
                    button.tag = index
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                    button.theme_setTitleColor("colors.black", forState: .normal)
                    button.theme_setTitleColor("colors.globalRedColor", forState: .selected)
                    button.addTarget(self, action: #selector(topTabButtonClicked), for: .touchUpInside)
                    scrollView.addSubview(button)
                    if index == 0 {
                        button.isSelected = true
                        privorButton = button
                    }
                    
                    // tableView
                    let tableView = UITableView(frame: CGRect(x: CGFloat(index) * screenWidth,
                                                              y: 0,
                                                              width: screenWidth,
                                                              height: bottomScrollView.height))
                    tableView.register(UINib(nibName: String(describing: UserDetailDongtaiCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserDetailDongtaiCell.self))
//                    if userDetail!.bottom_tab.count == 0 { tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 34, right: 0) }
                    tableView.delegate = self
                    tableView.dataSource = self
                    // 刚开始时不能滑动
                    tableView.isScrollEnabled = false
                    tableView.showsVerticalScrollIndicator = false
                    tableView.tableFooterView = UIView()
                    bottomScrollView.addSubview(tableView)
                    
                    if index == userDetail!.top_tab.count - 1 {
                        scrollView.contentSize = CGSize(width: button.frame.maxX,
                                                        height: scrollView.height)
                        bottomScrollView.contentSize = CGSize(width: tableView.frame.maxX,
                                                              height: bottomScrollView.height)
                    }
                }
                scrollView.addSubview(indicatorView)
            } else {
                topTabHeight.constant = 0
                topTabView.isHidden = true
            }
            layoutIfNeeded()
        }
    }
    
    /// topTab 指示条
    private lazy var indicatorView: UIView = {
        let indicatorView = UIView(frame: CGRect(x: (topTabButtonWidth - topTabindicatorWidth) * 0.5,
                                                 y: topTabView.height - 3,
                                                 width: topTabindicatorWidth,
                                                 height: topTabindicatorHeight))
        indicatorView.theme_backgroundColor = "colors.globalRedColor"
        return indicatorView
    }()
    
     //weak var privorButton = UIButton()
    var privorButton = UIButton()
    
    /// 推荐视图 view
    fileprivate lazy var relationRecommendView: RelationRecommendView = {
        let relationRecommendView = RelationRecommendView.loadViewFromNib()
        return relationRecommendView
    }()
    
    /// 背景图片
    @IBOutlet weak var backgroundImageView: UIImageView!
    /// 背景图片顶部约束
    @IBOutlet weak var bgImageViewTop: NSLayoutConstraint!
    /// 用户头像
    @IBOutlet weak var avatarImageView: AnimatableImageView!
    /// vip 图标
    @IBOutlet weak var vImageView: UIImageView!
    /// 用户名
    @IBOutlet weak var nameLabel: UILabel!
    /// 头条号图标
    @IBOutlet weak var toutiaohaoImageView: UIImageView!
    /// 发私信按钮
    @IBOutlet weak var sendMailButton: UIButton!
    /// 关注按钮
    @IBOutlet weak var concernButton: AnimatableButton!
    /// 推荐按钮
    @IBOutlet weak var recommendButton: AnimatableButton!
    @IBOutlet weak var recommendButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var recommendButtonTrailing: NSLayoutConstraint!
    /// 推荐 view
    @IBOutlet weak var recommendView: UIView!
    @IBOutlet weak var recommendViewHeight: NSLayoutConstraint!
    /// 头条认证
    @IBOutlet weak var verifiedAgencyLabel: UILabel!
    @IBOutlet weak var verifiedAgencyLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var verifiedAgencyLabelTop: NSLayoutConstraint!
    /// 认证内容
    @IBOutlet weak var verifiedContentLabel: UILabel!
    /// 地区
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var areaButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var areaButtonTop: NSLayoutConstraint!
    /// 描述内容
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
    /// 展开按钮
    @IBOutlet weak var unfoldButton: UIButton!
    @IBOutlet weak var unfoldButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var unfoldButtonWidth: NSLayoutConstraint!
    /// 关注数量
    @IBOutlet weak var followingsCountLabel: UILabel!
    /// 粉丝数量
    @IBOutlet weak var followersCountLabel: UILabel!
    // 文章 视频 问答
    @IBOutlet weak var topTabView: UIView!
    @IBOutlet weak var topTabHeight: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    /// 底层 view
    @IBOutlet weak var baseView: UIView!
    /// 底部的 scrollView
    @IBOutlet weak var bottomScrollView: UIScrollView!
    
    override func awakeFromNib() {
        super .awakeFromNib()
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
        concernButton.theme_setTitleColor("colors.userDetailConcernButtonTextColor", forState: .normal)
        concernButton.theme_setTitleColor("colors.userDetailConcernButtonSelectedTextColor", forState: .selected)
    }
}

// MARK: - tableView 的代理方法
extension UserDetailHeaderView: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            for subview in bottomScrollView.subviews {
                let tableview = subview as! UITableView
                tableview.isScrollEnabled = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserDetailDongtaiCell.self), for: indexPath) as! UserDetailDongtaiCell
        cell.dongtai = dongtais[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dongtai = dongtais[indexPath.row]
        return dongtai.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dongtais.count
    }
}

// MARK: - 按钮点击事件
extension UserDetailHeaderView {
    
    /// topTab 按钮点击事件
    @objc func topTabButtonClicked(button: UIButton) {
        privorButton.isSelected = false
        button.isSelected = !button.isSelected
        UIView.animate(withDuration: 0.25, animations: {
            self.indicatorView.centerX = button.centerX
            self.bottomScrollView.contentOffset = CGPoint(x: CGFloat(button.tag) * screenWidth,
                                                          y: 0)
        }) { (_) in
            self.privorButton = button
        }
    }
    
    /// 发私信 按钮点击
    @IBAction func sendMailButtonClicked() {
        let storyboard = UIStoryboard(name: String(describing: MoreLoginViewController.self), bundle: nil)
        let moreLoginVC = storyboard.instantiateViewController(withIdentifier: String(describing: MoreLoginViewController.self)) as! MoreLoginViewController
        moreLoginVC.modalSize = (width: .full, height: .custom(size: Float(screenHeight - (isIPhoneX ? 44 : 20))))
        UIApplication.shared.keyWindow?.rootViewController?.present(moreLoginVC, animated: true, completion: nil)
    }
    
    /// 关注 按钮点击
    @IBAction func concernButtonClicked(_ sender: AnimatableButton) {
        if sender.isSelected {
            // 以关注用户，取消关注
            NetWorkTool.loadRelationUnfollow(user_id: userDetail!.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.concernButton.theme_backgroundColor = "colors.globalRedColor"
                self.recommendButton.isHidden = true
                self.recommendButton.isSelected = false
                self.recommendButtonWidth.constant = 0
                self.recommendButtonTrailing.constant = 0
                self.recommendViewHeight.constant = 0
                UIView.animate(withDuration: 0.25) {
                    self.recommendButton.imageView?.transform = .identity
                    self.layoutIfNeeded()
                }
            }
        } else {
            // 未关注用户，点击关注
            NetWorkTool.loadRelationFollow(user_id: userDetail!.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.concernButton.theme_backgroundColor = "colors.userDetailFollowingConcernBtnBgColor"
                self.recommendButton.isHidden = false
                self.recommendButton.isSelected = false
                self.recommendButtonWidth.constant = 28.0
                self.recommendButtonTrailing.constant = 15.0
                self.recommendViewHeight.constant = 233.0
                UIView.animate(withDuration: 0.25, animations: {
                    self.layoutIfNeeded()
                }, completion: { (_) in
                    // 点击了关注按钮, 就会出现相关推荐视图
                    NetWorkTool.loadRelationUserRecommend(user_id: self.userDetail!.user_id, completionHandler: { (userCards) in
                        self.recommendView.addSubview(self.relationRecommendView)
                        self.relationRecommendView.userCards = userCards
                    })
                })
            }
        }
    }
    
    /// 推荐 展开按钮点击
    @IBAction func recommendButtonClicked(_ sender: AnimatableButton) {
        sender.isSelected = !sender.isSelected
        recommendViewHeight.constant = sender.isSelected ? 0 : 233.0
        relationRecommendView.labelHeight.constant = 0
        relationRecommendView.layoutIfNeeded()
        UIView.animate(withDuration: 0.25, animations: {
            sender.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat(sender.isSelected ? Double.pi : 0))
        })
    }
    
    /// 介绍 展开按钮点击
    @IBAction func unfoldButtonClicked() {
        unfoldButton.isHidden = true
        unfoldButtonWidth.constant = 0
        descriptionLabelHeight.constant = userDetail!.descriptionHeight
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        })
    }
}





