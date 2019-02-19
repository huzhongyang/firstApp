//
//  MyConcernCell.swift
//  News
//
//  Created by huzhongyang on 2018/11/20.
//  Copyright © 2018 huzhongyang. All rights reserved.
//

import UIKit
import Kingfisher

class MyConcernCell: UICollectionViewCell {
    /// 头像
    @IBOutlet weak var avatarImageView: UIImageView!
    /// vip
    @IBOutlet weak var vipImageView: UIImageView!
    /// 用户名
    @IBOutlet weak var nameLabel: UILabel!
    /// 新消息通知
    @IBOutlet weak var tipsButton: UIButton!
    
    var myConcern: MyConcern? {
        didSet {
            avatarImageView.kf.setImage(with: URL(string: (myConcern?.icon)!))
            nameLabel.text = myConcern?.name
            if let isVerify = myConcern?.is_verify {
                vipImageView.isHidden = !isVerify
            }
            if let tips = myConcern?.tips {
                tipsButton.isHidden = !tips
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tipsButton.layer.borderWidth = 1
        tipsButton.layer.borderColor = UIColor.white.cgColor
        
        theme_backgroundColor = "colors.cellBackgroundColor"
        nameLabel.theme_textColor = "colors.black"
    }
}
