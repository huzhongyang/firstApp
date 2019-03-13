//
//  DongtaiCommentCell.swift
//  News
//
//  Created by huzhongyang on 2019/3/11.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class DongtaiCommentCell: UITableViewCell {

    var comment = DongtaiComment() {
        didSet {
            vImageView.isHidden = !comment.user_verified
            nameLabel.text = comment.user_name != "" ? comment.user_name : ""
            if comment.user_auth_info.auth_info != "" { authInfoLabel.text = comment.user_auth_info.auth_info }
            if comment.user_profile_image_url != "" {
                avatarButton.kf.setImage(with: URL(string: comment.user_profile_image_url)!, for: .normal)
            } else if comment.avatar_url != "" {
                avatarButton.kf.setImage(with: URL(string: comment.avatar_url)!, for: .normal)
            } else if comment.user.user_id != 0 {
                avatarButton.kf.setImage(with: URL(string: comment.user.avatar_url)!, for: .normal)
                nameLabel.text = comment.user.screen_name
                vImageView.isHidden = !comment.user.user_verified
                if comment.user.user_auth_info.auth_info != "" { authInfoLabel.text = comment.user.user_auth_info.auth_info }
            }
            contentLabel.attributedText = comment.attributedContent
            timeLabel.text = comment.createTime + "· "
            if comment.reply_count != 0 { replayButton.theme_backgroundColor = "colors.grayColor240" }
            replayButton.setTitle(comment.reply_count == 0 ? "回复" : "\(comment.reply_count)回复", for: .normal)
            diggButton.setTitle(comment.digg_count == 0 ? "赞" : comment.diggCount, for: .normal)
            diggButton.isSelected = comment.user_digg
        }
    }
    
    /// 头像
    @IBOutlet weak var avatarButton: AnimatableButton!
    /// v
    @IBOutlet weak var vImageView: UIImageView!
    /// 用户名
    @IBOutlet weak var nameLabel: UILabel!
    /// 认证内容
    @IBOutlet weak var authInfoLabel: UILabel!
    /// 点赞
    @IBOutlet weak var diggButton: UIButton!
    /// 内容
    @IBOutlet weak var contentLabel: UILabel!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 回复
    @IBOutlet weak var replayButton: AnimatableButton!
    
    /// 点赞按钮点击
    @IBAction func diggButtonClicked(_ sender: UIButton) {
        
    }
    
    /// 回复按钮点击
    @IBAction func replayButtonClicked(_ sender: AnimatableButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
