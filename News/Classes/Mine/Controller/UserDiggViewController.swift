//
//  UserDiggViewController.swift
//  News
//
//  Created by huzhongyang on 2019/3/13.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserDiggViewController: UITableViewController {
    
    var userId = 0
    
    var digglist = [DongtaiUserDigg]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "赞过的人"
        SVProgressHUD.configuration()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: String(describing: UserDiggCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserDiggCell.self))
        tableView.mj_footer = RefreshAutoGifFooter(refreshingBlock: { [weak self] in
            // 获取动态详情的用户点赞列表数据
            NetWorkTool.loadDongtaiDetailUserDiggList(id: self!.userId, offset: self!.digglist.count) {
                if self!.tableView.mj_footer.isRefreshing { self!.tableView.mj_footer.endRefreshing() }
                self!.tableView.mj_footer.pullingPercent = 0.0
                if $0.count == 0 {
                    self!.tableView.mj_footer.endRefreshingWithNoMoreData()
                    SVProgressHUD.showInfo(withStatus: "没有更多数据啦!")
                    return
                }
                self!.digglist = $0
                self!.tableView.reloadData()
            }
        })
        tableView.mj_footer.beginRefreshing()
    }
}

// MARK: - Table view data source
extension UserDiggViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取出 userId
        let userId = digglist[indexPath.row].user_id
        let userDetailVC = UserDetailViewController2()
        userDetailVC.userId = userId
        navigationController?.pushViewController(userDetailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserDiggCell.self), for: indexPath) as! UserDiggCell
        cell.user = digglist[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return digglist.count
    }
}
