//
//  MineViewController.swift
//  News
//
//  Created by huzhongyang on 2018/11/18.
//  Copyright © 2018 huzhongyang. All rights reserved.
//

import UIKit
import SwiftTheme
import RxCocoa
import RxSwift

class MineViewController: UITableViewController {
    fileprivate let disposeBag = DisposeBag()
    // 存储 cell 数据
    var sections = [[MyCellModel]]()
    // 存储 我的关注数据
    var concerns = [MyConcern]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 隐藏 navigationBar
        navigationController?.navigationBar.isHidden = true
        // 隐藏多余 cell
        tableView.tableFooterView = UIView()
        // 头部视图
        tableView.tableHeaderView = headerView
        // 系统默认分割线
        tableView.separatorStyle = .none
        
        // 注册自定义 cell
        tableView.register(UINib(nibName: String(describing: MyOtherCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MyOtherCell.self))
        tableView.register(UINib(nibName: String(describing: MyFirstSectionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MyFirstSectionCell.self))
        
        // 获取我的 cell 的数据
        NetWorkTool.loadMyCellData { (sections) in
            let string = "{\"text\":\"我的关注\",\"grey_text\":\"\"}"
            let myConcern = MyCellModel.deserialize(from: string)
            var myConcerns = [MyCellModel]()
            myConcerns.append(myConcern!)
            self.sections.append(myConcerns)
            self.sections += sections
            self.tableView.reloadData()
            
            // 我的关注数据
            NetWorkTool.loadMyConcern(completionHandler: { (concerns) in
                self.concerns = concerns
                let indexSet = IndexSet(integer: 0)
                self.tableView.reloadSections(indexSet, with: .automatic)
            })
            
        }
        
        // 通过 RxSwift 来实现点击更多登录方式按钮后，弹出 MoreLoginViewController
        headerView.moreLoginButton.rx.controlEvent(UIControlEvents.touchUpInside)
            .subscribe(onNext: { [weak self] in
                let storyboard = UIStoryboard(name: String(describing: MoreLoginViewController.self), bundle: nil)
                let moreLoginVC = storyboard.instantiateViewController(withIdentifier: String(describing: MoreLoginViewController.self)) as! MoreLoginViewController
                moreLoginVC.modalSize = (width: .full, height: .custom(size: Float(screenHeight - (isIPhoneX ? 44 : 20))))
                self!.present(moreLoginVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    // 加载 heardView
    //private lazy var heardView = NoLoginHeaderView.loadViewFromNib()
    fileprivate lazy var headerView: NoLoginHeaderView = {
        let headerView = NoLoginHeaderView.loadViewFromNib()
        return headerView
    }()
}

extension MineViewController {
    // 点击 cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 3 {
            if indexPath.row == 1 { // 跳转到系统设置界面
                let settingVC = SettingViewController()
                settingVC.navigationItem.title = "设置"
                navigationController?.pushViewController(settingVC, animated: true)
            }
        }
    }
    
    // cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MyFirstSectionCell.self)) as! MyFirstSectionCell
            let section = sections[indexPath.section]
            cell.myCellModel = section[indexPath.row]
            // 判断 collectionView 是否隐藏
            if concerns.count == 0 || concerns.count == 1 {
                cell.collectionView.isHidden = true
            }
            
            if concerns.count == 1 {
                cell.myConcern = concerns[0]
            } else if concerns.count > 1 {
                cell.myConcerns = concerns
            }
            cell.delegate = (self as MyFirstSectionCellDelegate)
          return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MyOtherCell.self)) as! MyOtherCell
            let section = sections[indexPath.section]
            let myCellModel = section[indexPath.row]
            cell.leftLabel.text = myCellModel.text
            cell.rightLabel.text = myCellModel.grey_text
            return cell
        }
 }
    
    // 每行高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return (concerns.count == 0 || concerns.count == 1) ? 40 : 114
        }
        return 40
    }
    
    // 每组头部视图
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 10))
        view.theme_backgroundColor = "colors.tableViewBackgroundColor"
        return view
    }
    
    // 每组头部高度
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 0 : 10
    }
    
    // 组数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // 每组行数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            let totalOffset = mineHeaderViewHeight + abs(offsetY)
            let f = totalOffset / mineHeaderViewHeight
            headerView.bgImageView.frame = CGRect(x: -screenWidth * (f - 1) * 0.5, y: offsetY, width: screenWidth * f, height: totalOffset)
        }
    }
}

extension MineViewController: MyFirstSectionCellDelegate {
    
    /// 点击了第几个 cell
    func myFirstSectionCell(_ firstCell: MyFirstSectionCell, myConcern: MyConcern) {
        let userDetailVC = UserDetailViewController()
        userDetailVC.userId = myConcern.userid!
        navigationController?.pushViewController(userDetailVC, animated: true)
    }
}
