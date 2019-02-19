//
//  MyOtherCell.swift
//  News
//
//  Created by huzhongyang on 2018/11/20.
//  Copyright © 2018 huzhongyang. All rights reserved.
//

import UIKit

class MyOtherCell: UITableViewCell {
    /// 标题
    @IBOutlet weak var leftLabel: UILabel!
    /// 副标题
    @IBOutlet weak var rightLabel: UILabel!
    /// 右边箭头
    @IBOutlet weak var rightImageView: UIImageView!
    /// 分割线
    @IBOutlet weak var separetorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置主题
        leftLabel.theme_textColor = "colors.black"
        rightLabel.theme_textColor = "colors.cellRightTextColor"
        rightImageView.theme_image = "images.cellRightArrow"
        separetorView.theme_backgroundColor = "colors.separatorViewColor"
        theme_backgroundColor = "colors.cellBackgroundColor"
    }    
}
