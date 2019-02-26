//
//  HomeNavigationBarView.swift
//  News
//
//  Created by huzhongyang on 2019/2/26.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import IBAnimatable

class HomeNavigationBarView: UIView, NibLoadable {
    
    var didSelectedAvatarButton: (()->())?
    
    var didSelectedSearchButton: (()->())?
    
    /// 头像
    @IBOutlet weak var avatarButton: UIButton!
    /// 搜索
    @IBOutlet weak var searchButton: AnimatableButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchButton.contentHorizontalAlignment = .left
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        searchButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        searchButton.titleLabel?.lineBreakMode = .byTruncatingTail
        // 首页顶部导航栏搜索内容数据
        NetWorkTool.loadHomeSearchSuggestInfo { (suggestInfo) in
            self.searchButton.setTitle(suggestInfo, for: .normal)
        }
    }
    
    // 控件的固有属性大小
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
//    override var frame: CGRect {
//        didSet {
//            super.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 44)
//        }
//    }
    
    @IBAction func avatarButtonClicked(_ sender: UIButton) {
        didSelectedAvatarButton?()
    }
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        didSelectedSearchButton?()
    }
}
