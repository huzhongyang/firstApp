//
//  DongtaiDetailHeaderView.swift
//  News
//
//  Created by huzhongyang on 2019/3/10.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class DongtaiDetailHeaderView: UIView, NibLoadable {
    
    /// 点击了 点赞按钮
    var didSelectDiggButton: ((_ dongtai: UserDetailDongtai)->())?
    
    var dongtai = UserDetailDongtai() {
        didSet {
            avatarButton.kf.setImage(with: URL(string: dongtai.user.avatar_url), for: .normal)
            vImageView.isHidden = dongtai.user.user_verified
            nameLabel.text = dongtai.user.screen_name
            timeLabel.text = "· " + dongtai.createTime
            descriptionLabel.text = dongtai.user.verified_content
//            contentLabel.text = dongtai.content
            contentLabel.attributedText = dongtai.attributedContent
            contentLabel.height = Calculate.textHeight(text: dongtai.content, fontSize: 17, width: screenWidth - 30.0)
            readCount.text = dongtai.readCount + " 阅读"
            commentCountLabel.text = dongtai.commentCount + " 评论"
            zanButton.setTitle(dongtai.diggCount + " ", for: .normal)
            
            // 防止因 cell 的重用导致数据错乱
            if middleView.contains(postVideoOrArticleView) { postVideoOrArticleView.removeFromSuperview() }
            if middleView.contains(collectionView) { collectionView.removeFromSuperview() }
            if middleView.contains(originThreadView) { originThreadView.removeFromSuperview() }
            
            switch dongtai.item_type {
            case .postVideoOrArticle, .answerQuestion, .postVideo, .proposeQuestion, .forwardArticle, .postContentAndVideo:       // 发布了文章或视频
                postVideoOrArticleView.frame = CGRect(x: 15, y: 0, width: screenWidth - 30, height: middleView.height)
                // 如果 dongtai!.group 里没有数据的话，就从dongtaiQ!.origin_group 中加载数据
                if dongtai.group.title == "" {
                    postVideoOrArticleView.origin_group = dongtai.origin_group
                } else {
                    postVideoOrArticleView.group = dongtai.group
                }
                middleView.addSubview(postVideoOrArticleView)
                
            case .postContent, .postSmallVideo:                                                                                   // 发布了文字内容
                collectionView.isDongtaiDetail = true
                collectionView.frame = CGRect(x: 15, y: 0, width: dongtai.collectionViewW, height: dongtai.detailCollectionViewH)
                collectionView.thumbImageList = dongtai.thumb_image_list
                collectionView.largeImages = dongtai.large_image_list
                middleView.addSubview(collectionView)
                if dongtai.item_type == .postSmallVideo {
                    // 发布了小视频，暂时不处理
                    //                    collectionView.isPostSmallVideo = true
                }
                
            case .commentOrQuoteOthers, .commentOrQuoteContent:                                                                   // 引用评论
                originThreadView.originThread = dongtai.origin_thread
                originThreadView.originThread?.isDongtaiDetail = true
                originThreadView.frame = CGRect(x: 0, y: 0, width: screenWidth - 30, height: dongtai.origin_thread.detailHeight)
                middleView.addSubview(originThreadView)
            }
        }
    }
    
    /// 懒加载 引用或评论 view
    private lazy var originThreadView: DongtaiOriginThreadView = {
        let originThreadView = DongtaiOriginThreadView.loadViewFromNib()
        return originThreadView
    }()
    /// 懒加载 collectionView
    private lazy var collectionView: DongtaiCollectionView = {
        let collectionView = DongtaiCollectionView.loadViewFromNib()
        return collectionView
    }()
    /// 懒加载 发布视频或文章
    private lazy var postVideoOrArticleView: PostVideoOrArticleView = {
        let postVideoOrArticleView = PostVideoOrArticleView.loadViewFromNib()
        return postVideoOrArticleView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    /// 头像
    @IBOutlet weak var avatarButton: AnimatableButton!
    /// VIP 图标
    @IBOutlet weak var vImageView: UIImageView!
    /// 用户名
    @IBOutlet weak var nameLabel: UILabel!
    /// 创建时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 描述
    @IBOutlet weak var descriptionLabel: UILabel!
    ///
    @IBOutlet weak var separatorView: UIView!
    /// 阅读数量
    @IBOutlet weak var readCount: UILabel!
    /// 中间的 view
    @IBOutlet weak var middleView: UIView!
    /// 内容
    @IBOutlet weak var contentLabel: UILabel!
    /// 评论数量
    @IBOutlet weak var commentCountLabel: UILabel!
    /// 赞
    @IBOutlet weak var zanButton: UIButton!
    
    /// 覆盖按钮的点击
    @IBAction func coverButtonClicked() {
        
    }
    
    /// 点赞按钮点击
    @IBAction func diggButtonClicked(_ sender: UIButton) {
        didSelectDiggButton?(dongtai)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        height = dongtai.detailHeaderHeight
    }
}
