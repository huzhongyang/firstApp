//
//  UserDetailBottomPopController.swift
//  News
//
//  Created by huzhongyang on 2019/2/5.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit

class UserDetailBottomPopController: UIViewController {
    
    var childrenBottom = [BottomTabChildren]()
    
    var didSelectedChild: ((BottomTabChildren) -> ())?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
    }
}

extension UserDetailBottomPopController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(String(describing: "MyPresentatinControllerDismiss")), object: nil)
        didSelectedChild!(childrenBottom[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        cell.selectionStyle = .none
        let child = childrenBottom[indexPath.row]
        cell.textLabel?.text = child.name
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childrenBottom.count
    }
}
