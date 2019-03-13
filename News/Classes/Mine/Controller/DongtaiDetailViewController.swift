//
//  DongtaiDetailViewController.swift
//  News
//
//  Created by huzhongyang on 2019/3/10.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import SVProgressHUD
import IBAnimatable

class DongtaiDetailViewController: UIViewController {
    
    /// 评论数据
    private var comments = [DongtaiComment]()
    
    var dongtai = UserDetailDongtai() {
        didSet {
            navigationBar.user = dongtai.user
            headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: dongtai.detailHeaderHeight)
            headerView.dongtai = dongtai
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    /// emoji 图标
    @IBOutlet weak var emojiImageView: UIImageView!
    /// 评论按钮
    @IBOutlet weak var commentButton: UIButton!
    /// 点赞按钮
    @IBOutlet weak var diggButton: UIButton!
    /// 分享按钮
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var commentView: AnimatableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.keyWindow?.theme_backgroundColor = "colors.cellBackgroundColor"
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置 UI
        setupUI()
        // 点击事件
        selectedAction()
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

extension DongtaiDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navigationBar.titleLabel.isHidden = (scrollView.contentOffset.y >= 50)
        navigationBar.nameButton.isHidden = (scrollView.contentOffset.y <= 50)
        navigationBar.avatarButton.isHidden = (scrollView.contentOffset.y <=  50)
        navigationBar.followersButton.isHidden = (scrollView.contentOffset.y <= 50)
        navigationBar.vImageView.isHidden = (scrollView.contentOffset.y <= 50)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DongtaiCommentCell.self), for: indexPath) as! DongtaiCommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comment = comments[indexPath.row]
        let postCommentView = PostCommentView.loadViewFromNib()
        if comment.screen_name != "" {
            postCommentView.placeholderLabel.text = "回复 \(comment.screen_name):"
        } else if comment.user.user_id != 0 {
            if comment.user.screen_name != "" {
                postCommentView.placeholderLabel.text = "回复 \(comment.user.screen_name):"
            }
        }
        view.addSubview(postCommentView)
    }
}

// MARK: - 点击事件
extension DongtaiDetailViewController {
    
    /// 写评论覆盖的按钮点击
    @IBAction func coverButtonClicked(_ sender: UIButton) {
        // 弹出 postCommentView
        popPostCommentView(false)
    }
    
    /// 弹出 postCommentView
    func popPostCommentView(_ isEmojiButtonSelected: Bool) {
        let postCommentView = PostCommentView.loadViewFromNib()
        postCommentView.placeholderLabel.text = "优质评论将会被优先展示"
//        postCommentView.isEmojiButtonSelected = isEmojiButtonSelected
        UIApplication.shared.keyWindow?.backgroundColor = .white
        UIApplication.shared.keyWindow?.addSubview(postCommentView)
    }
    
    /// 点赞的按钮点击
    @IBAction func diggButtonClicked(_ sender: UIButton) {
        
    }
    
    /// 分享的按钮点击
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        
    }
    
    /// 点击事件
    private func selectedAction() {
        // 点击了 点赞按钮
        headerView.didSelectDiggButton = { [weak self] in
            let userDiggVC = UserDiggViewController()
            userDiggVC.userId = $0.id
            self!.navigationController?.pushViewController(userDiggVC, animated: true)
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

extension DongtaiDetailViewController {
    /// 设置界面
    private func setupUI() {
        tableView.theme_backgroundColor = "colors.cellBackgroundColor"
        commentView.theme_backgroundColor = "colors.grayColor240"
        diggButton.theme_setImage("images.tab_like_24x24_", forState: .normal)
        shareButton.theme_setImage("images.tab_share_24x24_", forState: .normal)
        emojiImageView.theme_image = "images.tabbar_icon_emoji_24x24_"
        commentButton.theme_setTitleColor("colors.black", forState: .normal)
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
        
        tableView.register(UINib(nibName: String(describing: DongtaiCommentCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DongtaiCommentCell.self))
        SVProgressHUD.configuration()
        switch dongtai.item_type {
        case .commentOrQuoteOthers, .commentOrQuoteContent, .forwardArticle:
            tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: { [weak self] in
                // 获取用户详情其他类型的详情的评论数据
                NetWorkTool.loadUserDetailQuoteDongtaiComments(id: self!.dongtai.id, offset: self!.comments.count, completionHandler: { (comments) in
                    self!.reloadData(comments)
                })
            })
        case .postContent:
            tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: { [weak self] in
                // 获取用户详情一般的详情的评论数据
                NetWorkTool.loadUserDetailNormalDongtaiComments(groupId: Int(self!.dongtai.id_str)!, offset: self!.comments.count, count: 20, completionHandler: { (comments) in
                    self!.reloadData(comments)
                })
            })
        default:
            break
        }
        tableView.mj_footer.beginRefreshing()
    }
    
    /// 刷新数据
    func reloadData(_ comments: [DongtaiComment]) {
        if tableView.mj_footer.isRefreshing { tableView.mj_footer.endRefreshing() }
        tableView.mj_footer.pullingPercent = 0.0
        if comments.count == 0 {
            tableView.mj_footer.endRefreshingWithNoMoreData()
            SVProgressHUD.showInfo(withStatus: "没有更多数据啦!")
            return
        }
        self.comments += comments
        tableView.reloadData()
    }
    
}
