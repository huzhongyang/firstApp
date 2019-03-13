//
//  DongtaiTableViewController.swift
//  News
//
//  Created by huzhongyang on 2019/3/12.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import SVProgressHUD

class DongtaiTableViewController: UITableViewController {
    
//    /// 点击了 cell
//    var didSelectCellWithDongtai: ((_ dongtai: UserDetailDongtai)->())?
    
    /// 动态列表 数据数组
    var dongtais = [UserDetailDongtai]()
    /// 文章列表 数据数组
    var articles = [UserDetailDongtai]()
    /// 视频列表 数据数组
    var videos = [UserDetailDongtai]()
    /// 问答列表 数据数组
    var wendas = [UserDetailWenda]()
    /// 小视频列表 数据数组
    var iesVideos = [UserDetailDongtai]()
    /// 记录当前的数据时候刷新过
    var isDongtaisShown = false
    var isArticlesShown = false
    var isVideosShown = false
    var isWendasShown = false
    var isIesVideosShown = false
    /// 刷新的指示器
    var maxCursor = 0
    var wendaCursor = ""
    /// 用户编号
    var userId = 0
    /// 当前选中的 topTab 的索引，点击了第几个
    var currentSelectedIndex = 0
    /// 当前 topTab 的类型
    var currentTopTabType: TopTabType = .dongtai {
        didSet {
            if !isDongtaisShown && !isArticlesShown && !isVideosShown && !isIesVideosShown && !isWendasShown {
                switch currentTopTabType {
                case .wenda:
                    tableView.register(UINib(nibName: String(describing: UserDetailWendaCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserDetailWendaCell.self))
                default:
                    tableView.register(UINib(nibName: String(describing: UserDetailDongtaiCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserDetailDongtaiCell.self))
                }
            }
            
            switch currentTopTabType {
            case .dongtai:
                if !isDongtaisShown {
                    isDongtaisShown = true
                    setFooter(tableView) { (dongtais) in
                        self.dongtais += dongtais
                        self.tableView.reloadData()
                    }
                    tableView.mj_footer.beginRefreshing()
                }
            case .article:
                if !isArticlesShown {
                    isArticlesShown = true
                    setFooter(tableView) { (articles) in
                        self.articles += articles
                        self.tableView.reloadData()
                    }
                    tableView.mj_footer.beginRefreshing()
                }
            case .video:
                if !isVideosShown {
                    isVideosShown = true
                    setFooter(tableView) { (videos) in
                        self.videos += videos
                        self.tableView.reloadData()
                    }
                    tableView.mj_footer.beginRefreshing()
                }
            case .wenda:
                if !isWendasShown {
                    // 加载问答的数据
                    NetWorkTool.loadUserDetailWendaList(user_id: userId, cursor: wendaCursor, completionHandler: {(cursor, wendas) in
                        self.wendas = wendas
                        self.wendaCursor = cursor
                        self.tableView.mj_footer.beginRefreshing()
                    })
                    isWendasShown = true
                    tableView.reloadData()
                }
                tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: { [weak self] in
                    /*
                     这里的加载 wenda 更多数据的接口拿到的数据 和 加载 wenda 数据的接口拿到的数据是一样的？？？？？？
                     并没有获得新的数据
                     **/
                    // 加载问答的更多数据
                    NetWorkTool.loadUserDetailLoadMoreWendaList(user_id: self!.userId, cursor: self!.wendaCursor, completionHandler: {(cursor, wendas) in
                        self!.wendaCursor = cursor
                        if self!.tableView.mj_footer.isRefreshing {
                            self!.tableView.mj_footer.endRefreshing()
                        }
                        self!.tableView.mj_footer.pullingPercent = 0.0
                        if wendas.count == 0 {
                            self!.tableView.mj_footer.endRefreshingWithNoMoreData()
                            SVProgressHUD.showInfo(withStatus: "没有更多数据啦!")
                            return
                        }
                        self!.wendas += wendas
                        self!.tableView.reloadData()
                    })
                })
            case .iesVideo:
                if !isIesVideosShown {
                    isIesVideosShown = true
                    setFooter(tableView) { (iesVideos) in
                        self.iesVideos += iesVideos
                        self.tableView.reloadData()
                    }
                    tableView.mj_footer.beginRefreshing()
                }
            }
        }
    }
    
    /// 设置 tableView 的刷新 footer
    ///
    /// - Parameters:
    ///   - tableView: 需要刷新的 tableView
    ///   - completionHandler: 刷新加载数据闭包回调
    private func setFooter(_ tableView: UITableView, completionHandler:@escaping ((_ datas: [UserDetailDongtai]) -> ())) {
        tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: { [weak self] in
            NetWorkTool.loadUserDetailDongtaiList(user_id: self!.userId, maxCursor: self!.maxCursor, completionHandler: { (cursor, dongtais) in
                if tableView.mj_footer.isRefreshing {
                    tableView.mj_footer.endRefreshing()
                }
                tableView.mj_footer.pullingPercent = 0.0
                if dongtais.count == 0 {
                    tableView.mj_footer.endRefreshingWithNoMoreData()
                    SVProgressHUD.showInfo(withStatus: "没有更多数据啦!")
                    return
                }
                completionHandler(dongtais)
                self!.maxCursor = cursor
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        SVProgressHUD.pasteConfiguration()
        if isIPhoneX { tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 34, right: 0) }
        tableView.theme_backgroundColor = "colors.cellBackgroundColor"
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.bouncesZoom = false
//        if currentTopTabType == .wenda {
//            tableView!.zy_registerCell(cell: UserDetailWendaCell.self)
//        }
//        else {
//            tableView!.zy_registerCell(cell: UserDetailDongtaiCell.self)
//
//        }
//        tableView.register(UINib(nibName: String(describing: UserDetailWendaCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserDetailWendaCell.self))
//        tableView.register(UINib(nibName: String(describing: UserDetailDongtaiCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserDetailDongtaiCell.self))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - tableView 的代理方法
extension DongtaiTableViewController {
    
    /// 跳转到下一个控制器
    private func pushNextViewController(_ dongtai: UserDetailDongtai) {
        switch dongtai.item_type {
        case .commentOrQuoteOthers, .commentOrQuoteContent, .forwardArticle, .postContent:
            let dongtaiDetailVC = DongtaiDetailViewController()
            dongtaiDetailVC.dongtai = dongtai
            navigationController?.pushViewController(dongtaiDetailVC, animated: true)
        case .postVideo, .postVideoOrArticle, .postContentAndVideo:
            SVProgressHUD.showInfo(withStatus: "跳转到视频控制器")
        case .proposeQuestion:
            print("")
            let wendaVC = WendaViewController()
//            wendaVC.qid = dongtai.id
//            wendaVC.enterForm = .dongtai
            navigationController?.pushViewController(wendaVC, animated: true)
        case .answerQuestion:
            SVProgressHUD.showInfo(withStatus: "sslocal 参数未知，无法获取数据！")
        case .postSmallVideo:
            SVProgressHUD.showInfo(withStatus: "请点击底部小视频 tabbar")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch currentTopTabType {
        case .dongtai:
            pushNextViewController(dongtais[indexPath.row])
        case .article:
            pushNextViewController(articles[indexPath.row])
        case .video:
            pushNextViewController(videos[indexPath.row])
        case .iesVideo:
            pushNextViewController(iesVideos[indexPath.row])
        case .wenda:
//            pushNextViewController(wendas[indexPath.row])
            SVProgressHUD.showInfo(withStatus: "sslocal 参数未知，无法获取数据！")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentTopTabType {
        case .dongtai:
            return cellFor(tableView, at: indexPath, with: dongtais)
        case .article:
            return cellFor(tableView, at: indexPath, with: articles)
        case .video:
            return cellFor(tableView, at: indexPath, with: videos)
        case .wenda:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserDetailWendaCell.self), for: indexPath) as! UserDetailWendaCell
            cell.wenda = wendas[indexPath.row]
            return cell
        case .iesVideo:
            return cellFor(tableView, at: indexPath, with: iesVideos)
        }
    }
    
    /// 设置 cell
    private func cellFor(_ tableView: UITableView, at indexPath: IndexPath, with datas: [UserDetailDongtai]) -> UserDetailDongtaiCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserDetailDongtaiCell.self), for: indexPath) as! UserDetailDongtaiCell
        cell.dongtai = datas[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch currentTopTabType {
        case .dongtai:
            return cellHeight(with: dongtais[indexPath.row])
        case .article:
            return cellHeight(with: articles[indexPath.row])
        case .video:
            return cellHeight(with: videos[indexPath.row])
        case .wenda:
            let wenda = wendas[indexPath.row]
            return wenda.cellHeight
        case .iesVideo:
            return cellHeight(with: iesVideos[indexPath.row])
        }
    }
    
    /// 返回 cell 的高度
    ///
    /// - Parameter dongtai: 动态内容的数据
    /// - Returns: cell 的高度
    private func cellHeight(with dongtai: UserDetailDongtai) -> CGFloat {
        return dongtai.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentTopTabType {
        case .dongtai:
            return dongtais.count
        case .article:
            return articles.count
        case .video:
            return videos.count
        case .wenda:
            return wendas.count
        case .iesVideo:
            return iesVideos.count
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 { tableView.contentOffset = CGPoint(x: 0, y: 0) }
    }
}
