//
//  OfflineDownloadController.swift
//  News
//
//  Created by huzhongyang on 2019/1/11.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit

class OfflineDownloadController: UITableViewController {

    /// 标题数组
    fileprivate var titles = [HomeNewsTitle]()
    /// 标题数据库
    fileprivate let newsTitleTable = NewsTitleTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: OfflineDownloadCell.self), bundle: nil), forCellReuseIdentifier: String(describing: OfflineDownloadCell.self))
        tableView.rowHeight = 44
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // 从数据库中取出所有数据，赋值给标题数组 titles
        titles = newsTitleTable.selectAll()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取出数组中的第 row 个对象
        var homeNewsTitle = titles[indexPath.row]
        // 取反
        homeNewsTitle.selected = !homeNewsTitle.selected
        // 取出第 row 个 cell
        let cell = tableView.cellForRow(at: indexPath) as! OfflineDownloadCell
        // 改变 cell 的图片
        cell.rightImageView.theme_image = homeNewsTitle.selected ? "images.air_download_option_press" : "images.air_download_option"
        // 替换数组中的数据
        titles[indexPath.row] = homeNewsTitle
        // 更新数据库中的数据
        newsTitleTable.update(homeNewsTitle)
        
        //tableView.reloadRows(at: [indexPath], with: .none)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        view.theme_backgroundColor = "colors.tableViewBackgroundColor"
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: screenWidth, height: 44))
        label.text = "我的频道"
        label.theme_textColor = "colors.black"
        let separatorView = UIView(frame: CGRect(x: 0, y: 43, width: screenWidth, height: 1))
        view.addSubview(separatorView)
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OfflineDownloadCell.self), for: indexPath) as! OfflineDownloadCell
        let newsTitle = titles[indexPath.row]
        cell.titleLabel.text = newsTitle.name
        cell.rightImageView.theme_image = newsTitle.selected ? "images.air_download_option_press" : "images.air_download_option"
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles.count
    }
}
