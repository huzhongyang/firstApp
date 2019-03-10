//
//  DongtaiDetailViewController.swift
//  News
//
//  Created by huzhongyang on 2019/3/10.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit

class DongtaiDetailViewController: UITableViewController {
    
    var dongtai = UserDetailDongtai() {
        didSet {
            
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
    
    /// 懒加自定义载导航栏头部
    private lazy var navigationBar: DongtaiDetailNavigationBar = {
       let navigationBar = DongtaiDetailNavigationBar.loadViewFromNib()
        return navigationBar
    }()

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}

extension DongtaiDetailViewController {
    /// 设置 UI
    func setupUI() {
        tableView.theme_backgroundColor = "colors.cellBackgroundColor"
        navigationItem.titleView = navigationBar
    }
}
