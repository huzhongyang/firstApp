//
//  DongtaiDetailNavigationBar.swift
//  News
//
//  Created by huzhongyang on 2019/3/10.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class DongtaiDetailNavigationBar: UIView, NibLoadable {
    
    var user = DongtaiUser() {
        didSet {
            avatarButton.kf.setImage(with: URL(string: user.avatar_url), for: .normal)
            nameButton.setTitle(user.screen_name, for: .normal)
            followersButton.setTitle(user.followersCount, for: .normal)
        }
    }
    
    /// 头像
    @IBOutlet weak var avatarButton: AnimatableButton!
    /// VIP 图标
    @IBOutlet weak var vImageView: UIImageView!
    /// 用户名
    @IBOutlet weak var nameButton: UIButton!
    /// 粉丝数量
    @IBOutlet weak var followersButton: UIButton!
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // 实现这个方法后 titleLabel 的位置会偏
//    override var intrinsicContentSize: CGSize {
//        return UIView.layoutFittingExpandedSize
//    }
}
