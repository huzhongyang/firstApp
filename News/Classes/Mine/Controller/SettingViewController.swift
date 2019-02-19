//
//  SettingViewController.swift
//  News
//
//  Created by huzhongyang on 2018/12/25.
//  Copyright © 2018 huzhongyang. All rights reserved.
//

import UIKit
import Kingfisher

class SettingViewController: UITableViewController {

    /// 存储 plist 文件中的数据
    var sections = [[SettingModel]]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 设置状态栏属性
        navigationController?.navigationBar.barStyle = .default
        // 显示 navigationBar
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置界面
        setupUI()
    }
}

// MARK: - 功能方法
extension SettingViewController {
    
    /// 非 Wi-Fi 网络播放提醒
    fileprivate func setupPlayNoticeAlertController(_ cell: SettingCell) {
        let alertController = UIAlertController(title: "非 Wi-Fi 网络播放提醒", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let everyAction = UIAlertAction(title: "每次提醒", style: .default) { (_) in
            cell.rightTitleLable.text = "每次提醒"
        }
        let onceAction = UIAlertAction(title: "提醒一次", style: .default) { (_) in
            cell.rightTitleLable.text = "提醒一次"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(everyAction)
        alertController.addAction(onceAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// 非 Wi-Fi 网络流量提醒
    fileprivate func setupNetworkAlertController(_ cell: SettingCell) {
        let alertController = UIAlertController(title: "非 Wi-Fi 网络流量提醒", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let bestAction = UIAlertAction(title: "最好佳效果(下载大图)", style: .default) { (_) in
            cell.rightTitleLable.text = "最佳效果(下载大图)"
        }
        let betterAction = UIAlertAction(title: "较省流量(智能下图)", style: .default) { (_) in
            cell.rightTitleLable.text = "较省流量(智能下图)"
        }
        let leastAction = UIAlertAction(title: "极省流量(智能下图)", style: .default) { (_) in
            cell.rightTitleLable.text = "极省流量(智能下图)"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(bestAction)
        alertController.addAction(betterAction)
        alertController.addAction(leastAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// 设置字体大小
    fileprivate func setupFontAlertController(_ cell: SettingCell) {
        let alertController = UIAlertController(title: "设置字体大小", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let smallAction = UIAlertAction(title: "小", style: .default) { (_) in
            cell.rightTitleLable.text = "小"
        }
        let middleAction = UIAlertAction(title: "中", style: .default) { (_) in
            cell.rightTitleLable.text = "中"
        }
        let bigAction = UIAlertAction(title: "大", style: .default) { (_) in
            cell.rightTitleLable.text = "大"
        }
        let largeAction = UIAlertAction(title: "特大", style: .default) { (_) in
            cell.rightTitleLable.text = "特大"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(smallAction)
        alertController.addAction(middleAction)
        alertController.addAction(bigAction)
        alertController.addAction(largeAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// 弹出清理缓存提示框
    fileprivate func clearCacheAlertController(_ cell: SettingCell) {
        let alertController = UIAlertController(title: "确定清楚所有缓存?问答草稿、离线下载及图片均会被清除", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default) { (_) in
            let cache = KingfisherManager.shared.cache
            cache.clearDiskCache()
            cache.clearMemoryCache()
            cache.cleanExpiredDiskCache()
            // cell 更改缓存大小
            cell.rightTitleLable.text = "0.00M"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// 从沙盒中获取缓存大小 并 显示到 cell 上
    fileprivate func calculateDiskCashSize(_ cell: SettingCell) {
        let cache = KingfisherManager.shared.cache
        cache.calculateDiskCacheSize { (size) in
            // 转化成 M
            let sizeM = Double(size) / 1024.0 / 1024.0
            cell.rightTitleLable.text = String(format: "%.2fM", sizeM)
        }
    }
}

// MARK: - cell
extension SettingViewController {
    
    /// 点击 cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! SettingCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: // 清理缓存
                clearCacheAlertController(cell)
            case 1: // 设置字体大小
                setupFontAlertController(cell)
            case 3: // 非 Wi-Fi 网络流量提醒
                setupNetworkAlertController(cell)
            case 4: // 非 Wi-Fi 网络播放提醒
                setupPlayNoticeAlertController(cell)
            default: break
            }
        case 1:
            switch indexPath.row {
            case 0: // 离线下载界面
                let offlineDownloadVC = OfflineDownloadController()
                offlineDownloadVC.navigationItem.title = "离线下载"
                navigationController?.pushViewController(offlineDownloadVC, animated: true)
            default: break
            }
        default: break
        }
    }
    
    /// cell 初始化
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingCell.self), for: indexPath) as! SettingCell
        let rows = sections[indexPath.section]
        cell.setting = rows[indexPath.row]
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: // 计算缓存大小
                calculateDiskCashSize(cell)
            case 2:
                cell.selectionStyle = .none
            case 5:
                cell.selectionStyle = .none
            default: break
            }
        default: break
        }
        
        return cell
    }
}

extension SettingViewController {
    
    fileprivate func setupUI() {
        // plist 文件路径
        let path = Bundle.main.path(forResource: "settingPlist", ofType: "plist")
        let cellPlist = NSArray(contentsOfFile: path!) as! [Any]
//        for dicts in cellPlist {
//            let array = dicts as! [[String: Any]]
//            var rows = [SettingModel]()
//            for dict in array {
//                let setting = SettingModel.deserialize(from: dict as Dictionary)
//                rows.append(setting!)
//            }
//            sections.append(rows)
//        }
        sections = cellPlist.compactMap({ section in
            (section as! [Any]).compactMap({ row in
                SettingModel.deserialize(from: row as? NSDictionary)
            })
        })
        // 注册 SettingCell
        tableView.register(UINib(nibName: String(describing: SettingCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SettingCell.self))
        
        tableView.rowHeight = 44
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
}

// MARK: - SettingViewController data source
extension SettingViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 10))
        view.backgroundColor = UIColor.globalBackgroundColor()
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
