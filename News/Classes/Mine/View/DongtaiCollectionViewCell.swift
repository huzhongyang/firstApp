//
//  DongtaiCollectionViewCell.swift
//  News
//
//  Created by huzhongyang on 2019/2/17.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import Kingfisher

class DongtaiCollectionViewCell: UICollectionViewCell {
    
    /// collectionView 上的缩略图
    var thumbImage: ThumbImage? {
        didSet {
            thumbImageView.kf.setImage(with: URL(string: thumbImage!.urlString))
        }
    }
    
    /// 大图
    var largeImage: LargeImage? {
        didSet {
            thumbImageView.kf.setImage(with: URL(string: largeImage!.urlString))
        }
    }

    @IBOutlet weak var thumbImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
