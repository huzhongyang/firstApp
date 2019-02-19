//
//  UserDetailBottomPushController.swift
//  News
//
//  Created by huzhongyang on 2019/2/5.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import WebKit

class UserDetailBottomPushController: UIViewController {

    var url: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = WKWebView()
        webView.frame = view.frame
        webView.load(URLRequest(url: URL(string: url!)!))
        view.addSubview(webView)
    }
}
