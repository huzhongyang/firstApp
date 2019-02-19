//
//  NavigationBarView.swift
//  News
//
//  Created by huzhongyang on 2019/1/16.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import IBAnimatable

class NavigationBarView: UIView, NibLoadable {
    
    var userDetail: UserDetail? {
        didSet {
            nameLabel.text = userDetail!.screen_name
            concernButton.isSelected = userDetail!.is_following
            concernButton.theme_backgroundColor = userDetail!.is_following ? "colors.userDetailFollowingConcernBtnBgColor" : "colors.userDetailConcernBtnBgColor"
            concernButton.borderColor = userDetail!.is_following ? UIColor(r: 232, g: 232, b: 232) : UIColor(r: 230, g: 100, b: 95)
            concernButton.borderWidth = userDetail!.is_following ? 1 : 0
        }
    }
    
    
    var goBackButtonClicked: (() -> ())?
    
    /// 标题
    @IBOutlet weak var nameLabel: UILabel!
    /// 关注按钮
    @IBOutlet weak var concernButton: AnimatableButton!
    /// 导航栏
    @IBOutlet weak var navigationBar: UIView!
    /// 返回按钮
    @IBOutlet weak var returnButton: UIButton!
    /// 更多按钮
    @IBOutlet weak var moreButton: UIButton!
    
    /// 关注按钮点击
    @IBAction func concernButtonClicked(_ sender: AnimatableButton) {
        if sender.isSelected { // 已关注, 点击取消关注
            NetWorkTool.loadRelationUnfollow(user_id: userDetail!.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.concernButton.theme_backgroundColor = "colors.globalRedColor"
                self.concernButton.borderWidth = 0
            }
        } else { // 未关注, 点击关注
            NetWorkTool.loadRelationFollow(user_id: userDetail!.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.concernButton.theme_backgroundColor = "colors.userDetailFollowingConcernBtnBgColor"
                self.concernButton.borderColor = UIColor(r: 232, g: 232, b: 232)
                self.concernButton.borderWidth = 1
            }
        }
    }
    
    /// 返回按钮 点击事件
    @IBAction func returnButtonCliked(_ sender: UIButton) {
        goBackButtonClicked?()
    }
    
    /// 更多按钮 点击事件
    @IBAction func moreButtonCliked(_ sender: UIButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        returnButton.theme_setImage("images.personal_home_back_white_24x24_", forState: .normal)
        moreButton.theme_setImage("images.new_morewhite_titlebar_22x22_", forState: .normal)
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
        concernButton.theme_setTitleColor("colors.userDetailConcernButtonTextColor", forState: .normal)
        concernButton.theme_setTitleColor("colors.userDetailConcernButtonSelectedTextColor", forState: .selected)
    }
    
    // view 的最后一次布局
    override func layoutSubviews() {
        super.layoutSubviews()
        height = navigationBar.frame.maxY
    }
}
