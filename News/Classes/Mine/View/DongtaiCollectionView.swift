//
//  DongtaiCollectionView.swift
//  News
//
//  Created by huzhongyang on 2019/2/22.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit

class DongtaiCollectionView: UICollectionView, NibLoadable {

    var thumbImageList = [ThumbImage]() {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate = self
        register(UINib(nibName: String(describing: DongtaiCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: DongtaiCollectionViewCell.self))
        collectionViewLayout = DongtaiCollectionViewFlowLayout()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension DongtaiCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DongtaiCollectionViewCell.self), for: indexPath) as! DongtaiCollectionViewCell
        cell.thumbImage = thumbImageList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Calculate.collectionViewCellSize(thumbImageList.count)
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
