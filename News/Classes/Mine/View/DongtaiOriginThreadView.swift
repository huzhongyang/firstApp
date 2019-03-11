//
//  DongtaiOriginThreadView.swift
//  News
//
//  Created by huzhongyang on 2019/2/22.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit

class DongtaiOriginThreadView: UIView, NibLoadable {

    let emojiManager = EmojiManger()
    
    var originThread: DongtaiOriginThread? {
        didSet {
            let mutableAttributedString = NSMutableAttributedString(string: "@\(originThread!.user.screen_name)", attributes: [.foregroundColor: UIColor.textBlue()])
            mutableAttributedString.append(emojiManager.showEmoji(content: originThread!.content, font: contentLabel.font))
            contentLabel.attributedText = mutableAttributedString
            contentLabelHeight.constant = originThread!.contentH!
            collectionView.isDongtaiDetail = originThread!.isDongtaiDetail
            collectionView.thumbImageList = originThread!.thumb_image_list
            collectionView.largeImages = originThread!.large_image_list
            collectionViewWidth.constant = originThread!.collectionViewW
            layoutIfNeeded()
        }
    }
    
    /// 引用内容 Label
    @IBOutlet weak var contentLabel: UILabel!
    /// 引用内容 Label 的高度
    @IBOutlet weak var contentLabelHeight: NSLayoutConstraint!
    /// 引用内容的 collectionView
    @IBOutlet weak var collectionView: DongtaiCollectionView!
    
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        height = originThread!.height!
        width = screenWidth
    }
}
