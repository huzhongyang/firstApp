//
//  RelationRecommendView.swift
//  News
//
//  Created by huzhongyang on 2019/2/10.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit

class RelationRecommendView: UIView, NibLoadable {
    
    var userCards = [UserCard]()

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.collectionViewLayout = RelationRecommendFlowLayout()
        collectionView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: RelationRecommendCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: RelationRecommendCell.self))
    }
}

extension RelationRecommendView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RelationRecommendCell.self), for: indexPath) as! RelationRecommendCell
        cell.userCard = userCards[indexPath.item]
        return cell
    }
}

class RelationRecommendFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        itemSize = CGSize(width: 142, height: 190)
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
