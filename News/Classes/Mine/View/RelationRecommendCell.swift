//
//  RelationRecommendCell.swift
//  News
//
//  Created by huzhongyang on 2019/2/10.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class RelationRecommendCell: UICollectionViewCell {
    
    var userCard: UserCard? {
        didSet {
            nameLabel.text = userCard!.user.info.name
            avatarImageView.kf.setImage(with: URL(string: userCard!.user.info.avatar_url))
            vImageView.isHidden = (userCard!.user.info.user_auth_info == "") ? true : false
            recommendReasonLabel.text = userCard!.recommend_reason
        }
    }
    
    /// 头像
    @IBOutlet weak var avatarImageView: AnimatableImageView!
    
    /// VIP 头像
    @IBOutlet weak var vImageView: UIImageView!

    /// 用户名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 推荐原因
    @IBOutlet weak var recommendReasonLabel: UILabel!
    
    /// 加载图标
    @IBOutlet weak var loadingImageView: UIImageView!
    
    /// 关注按钮
    @IBOutlet weak var concernButton: AnimatableButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
        concernButton.theme_setTitleColor("colors.userDetailConcernButtonTextColor", forState: .normal)
        concernButton.theme_setTitleColor("colors.userDetailConcernButtonSelectedTextColor", forState: .selected)
    }
    
    /// 关注按钮点击
    @IBAction func concernButtonClicked(_ sender: AnimatableButton) {
        loadingImageView.isHidden = false
        loadingImageView.layer.add(animation, forKey: nil)
        if sender.isSelected { // 已关注, 点击取消关注
            NetWorkTool.loadRelationUnfollow(user_id: userCard!.user.info.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.loadingImageView.layer.removeAllAnimations()
                self.loadingImageView.isHidden = true
                self.concernButton.theme_backgroundColor = "colors.globalRedColor"
                self.concernButton.borderWidth = 0
            }
        } else { // 未关注, 点击关注
            NetWorkTool.loadRelationFollow(user_id: userCard!.user.info.user_id) { (_) in
                sender.isSelected = !sender.isSelected
                self.loadingImageView.layer.removeAllAnimations()
                self.loadingImageView.isHidden = true
                self.concernButton.theme_backgroundColor = "colors.userDetailFollowingConcernBtnBgColor"
                self.concernButton.borderColor = UIColor(r: 232, g: 232, b: 232)
                self.concernButton.borderWidth = 1
            }
        }
    }
    
    /// 旋转动画
    private lazy var animation: CABasicAnimation = {
       let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = Double.pi * 2
        animation.duration = 1.5
        animation.autoreverses = false
        animation.repeatCount = MAXFLOAT
       return animation
    }()
}
