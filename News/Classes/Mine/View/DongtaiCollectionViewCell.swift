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
    
    var thumbImage: ThumbImage? {
        didSet {
            thumbImageView.kf.setImage(with: URL(string: thumbImage!.urlString))
        }
    }

    @IBOutlet weak var thumbImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
