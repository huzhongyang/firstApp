//
//  OfflineDownloadCell.swift
//  News
//
//  Created by huzhongyang on 2019/1/11.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit

class OfflineDownloadCell: UITableViewCell {
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    /// 勾选图片
    @IBOutlet weak var rightImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
