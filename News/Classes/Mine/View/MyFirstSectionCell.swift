//
//  MyFirstSectionCell.swift
//  News
//
//  Created by huzhongyang on 2018/11/20.
//  Copyright © 2018 huzhongyang. All rights reserved.
//

import UIKit

protocol MyFirstSectionCellDelegate: class {
    /// 点击了第几个 cell
    func myFirstSectionCell(_ firstCell: MyFirstSectionCell, myConcern: MyConcern)
}

class MyFirstSectionCell: UITableViewCell {
    
    weak var delegate: MyFirstSectionCellDelegate?
    
    /// 标题
    @IBOutlet weak var leftLabel: UILabel!
    /// 副标题
    @IBOutlet weak var rightLabel: UILabel!
    /// 右边箭头
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    /// 分割线
    @IBOutlet weak var separatorView: UIView!
    /// 上部视图
    @IBOutlet weak var topView: UIView!
    
    var myCellModel: MyCellModel? {
        didSet {
            leftLabel.text = myCellModel?.text
            rightLabel.text = myCellModel?.grey_text
        }
    }
    
    var myConcerns = [MyConcern]() {
        didSet {
            collectionView.reloadData()
        }
    }
 
    var myConcern: MyConcern? {
        didSet {
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置主题
        leftLabel.theme_textColor = "colors.black"
        rightLabel.theme_textColor = "colors.cellRightTextColor"
        rightImageView.theme_image = "images.cellRightArrow"
        topView.theme_backgroundColor = "colors.cellBackgroundColor"
        collectionView.theme_backgroundColor = "colors.separatorViewColor"
        separatorView.theme_backgroundColor = "colors.separatorViewColor"
        theme_backgroundColor = "colors.cellBackgroundColor"
        
        collectionView.collectionViewLayout = MyConcernFlowLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 注册 MyConcernCell
        collectionView.register(UINib(nibName: String(describing: MyConcernCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MyConcernCell.self))
    }
}

extension MyFirstSectionCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let myConcern = myConcerns[indexPath.item]
        delegate?.myFirstSectionCell(self, myConcern: myConcern)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MyConcernCell.self), for: indexPath) as! MyConcernCell
        cell.myConcern = myConcerns[indexPath.item]
    
        return cell
    }
    
    // collecionView 中 item 个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myConcerns.count
    }
}

class MyConcernFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        // 每个 cell 的大小
        itemSize = CGSize(width: 58, height: 74)
        // 横向间距
        minimumLineSpacing = 0
        // 纵向间距
        minimumInteritemSpacing = 0
        // cell 上下左右的间距
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // 设置水平滚动
        scrollDirection = .horizontal
    }
}
