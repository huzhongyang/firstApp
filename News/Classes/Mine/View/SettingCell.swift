//
//  SettingCell.swift
//  News
//
//  Created by huzhongyang on 2018/12/25.
//  Copyright © 2018 huzhongyang. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    var setting: SettingModel? {
        didSet {
            titleLabel.text = setting!.title
            subtitleLabel.text = setting!.subtitle
            rightTitleLable.text = setting!.rightTitle
            arrowImageView.isHidden = setting!.isHiddenRightArrow
            switchView.isHidden = setting!.isHiddenSwitch
            if !subtitleLabel.isHidden {
                subtitleLabelHeight.constant = 20
                layoutIfNeeded()
            }
        }
    }
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    /// 副标题
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var subtitleLabelHeight: NSLayoutConstraint!
    /// 右边标题
    @IBOutlet weak var rightTitleLable: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var bottomLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
