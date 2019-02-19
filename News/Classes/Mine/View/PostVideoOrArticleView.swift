//
//  PostVideoOrArticleView.swift
//  News
//
//  Created by huzhongyang on 2019/2/17.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import Kingfisher

class PostVideoOrArticleView: UIView, NibLoadable {
    
    var group: DongtaiOriginGroup? {
        didSet {
            titleLabel.text = group!.title
            iconButton.kf.setBackgroundImage(with: URL(string: group!.image_url), for: .normal)
            switch group!.media_type {
            case .postArticle:
                iconButton.setImage(nil, for: .normal)
            case .postVideo:
                iconButton.setImage(UIImage(named: "smallvideo_all_32x32_"), for: .normal)
            }
        }
    }
    
    
    /// 图标
    @IBOutlet weak var iconButton: UIButton!
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 覆盖按钮的点击
    @IBAction func coverButtonClicked(_ sender: UIButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
