//
//  DongtaiCollectionViewCell.swift
//  News
//
//  Created by huzhongyang on 2019/2/17.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD

class DongtaiCollectionViewCell: UICollectionViewCell {
    
    var isPostSmallVideo = false {
        didSet {
            if isPostSmallVideo {
                iconButton.setImage(UIImage(named: "smallvideo_all_32x32_"), for: .normal)
            }
        }
    }
    
    /// collectionView 上的缩略图
    var thumbImage: ThumbImage? {
        didSet {
            thumbImageView.kf.setImage(with: URL(string: thumbImage!.urlString))
        }
    }
    
    /// 大图
    var largeImage: LargeImage? {
        didSet {
//            thumbImageView.kf.setImage(with: URL(string: largeImage!.urlString))
            thumbImageView.kf.setImage(with: URL(string: largeImage!.urlString), placeholder: nil, options: nil, progressBlock: { (receivedSize, totalSize) in
                // 图片加载进度
                let progress = Float(receivedSize) / Float(totalSize)
                SVProgressHUD.showProgress(progress)
                SVProgressHUD.setBackgroundColor(.clear)
                SVProgressHUD.setForegroundColor(.white)
            }) { (image, error, cacheType, imageURL) in
                // 图片加载完成后移除加载进度图
                SVProgressHUD.dismiss()
            }
        }
    }

    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var iconButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
