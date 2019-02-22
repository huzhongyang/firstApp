//
//  UserDetailDongtaiCell.swift
//  News
//
//  Created by huzhongyang on 2019/2/14.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import IBAnimatable

class UserDetailDongtaiCell: UITableViewCell {
    
    var dongtai: UserDetailDongtai? {
        didSet {
            avatarImageView.kf.setImage(with: URL(string: dongtai!.user.avatar_url))
            nameLabel.text = dongtai!.user.screen_name
            likeButton.setTitle(dongtai!.diggCount, for: .normal)
            commentButton.setTitle(dongtai!.commentCount, for: .normal)
            forwardButton.setTitle(dongtai!.forwardCount, for: .normal)
            areaLabel.text = dongtai!.position.position + " "
            readCountLabel.text = dongtai!.readCount + "阅读"
            contentLabel.text = dongtai!.content
            contentLabelHeight.constant = dongtai!.contentH
            allContentLabel.isHidden = dongtai!.contentH >= 110.0 ? false : true
            
            // 防止因为 cell 的重用机制, 导致数据的错乱
            if middleView.contains(postVideoOrArticleView) {
                postVideoOrArticleView.removeFromSuperview()
            }
            if middleView.contains(collectionView) {
                collectionView.removeFromSuperview()
            }
            if middleView.contains(originThreadView) {
                originThreadView.removeFromSuperview()
            }
            
            switch dongtai!.item_type {
            case .postVideoOrArticle: // 发布了文章或视频
                middleView.addSubview(postVideoOrArticleView)
                postVideoOrArticleView.frame = CGRect(x: 15, y: 0, width: screenWidth - 30, height: middleView.height)
                postVideoOrArticleView.group = dongtai!.group
                
            case .postContent: // 发布了文字内容
                middleView.addSubview(collectionView)
                collectionView.frame = CGRect(x: 15, y: 0, width: dongtai!.collectionViewW, height: dongtai!.collectionViewH)
                collectionView.reloadData()
                
            case .commentOrQuoteContent: // 引用或评论
                middleView.addSubview(originThreadView)
                originThreadView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: dongtai!.origin_thread.height!)
                originThreadView.originThread = dongtai!.origin_thread
            }
        }
    }
    
    /// 懒加载 引用或评论 view
    private lazy var originThreadView: DongtaiOriginThreadView = {
        let originThreadView = DongtaiOriginThreadView.loadViewFromNib()
        return originThreadView
    }()
    
    private lazy var collectionView: UICollectionView = {
       let collectionView = UICollectionView(frame: .zero, collectionViewLayout: DongtaiCollectionViewFlowLayout())
        collectionView.register(UINib(nibName: String(describing: DongtaiCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: DongtaiCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.theme_backgroundColor = "colors.cellBackgroundColor"
        return collectionView
    }()
    
    /// 懒加载 发布视频或文章
    private lazy var postVideoOrArticleView: PostVideoOrArticleView = {
        let postVideoOrArticleView = PostVideoOrArticleView.loadViewFromNib()
        return postVideoOrArticleView
    }()
    
    /// 头像
    @IBOutlet weak var avatarImageView: AnimatableImageView!
    /// 用户名
    @IBOutlet weak var nameLabel: UILabel!
    /// 修改时间
    @IBOutlet weak var modifyTimeLabel: UILabel!
    /// 位置
    @IBOutlet weak var areaLabel: UILabel!
    /// 阅读数
    @IBOutlet weak var readCountLabel: UILabel!
    /// 点赞按钮
    @IBOutlet weak var likeButton: UIButton!
    /// 评论按钮
    @IBOutlet weak var commentButton: UIButton!
    /// 转发按钮
    @IBOutlet weak var forwardButton: UIButton!
    /// 全文 Label
    @IBOutlet weak var contentLabel: UILabel!
    /// 全文 Label 高度
    @IBOutlet weak var contentLabelHeight: NSLayoutConstraint!
    /// 显示全文 Label
    @IBOutlet weak var allContentLabel: UILabel!
    /// 中间内容下面的 view
    @IBOutlet weak var middleView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension UserDetailDongtaiCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dongtai!.thumb_image_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DongtaiCollectionViewCell.self), for: indexPath) as! DongtaiCollectionViewCell
        cell.thumbImage = dongtai!.thumb_image_list[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Calculate.collectionViewCellSize(dongtai!.thumb_image_list.count)
    }
}

// 代码创建 collectionview 时, 必须指定一个布局样式, 否则会报错.
// 从 xib 创建不用, 因为 xib 中已经有了一个布局样式
class DongtaiCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        minimumLineSpacing = 5
        minimumInteritemSpacing = 5
    }
}
