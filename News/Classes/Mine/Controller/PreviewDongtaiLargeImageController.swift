//
//  PreviewDongtaiLargeImageController.swift
//  News
//
//  Created by huzhongyang on 2019/2/27.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD
import Photos

class PreviewDongtaiLargeImageController: UIViewController {
    
    /// 图片数组
    var images = [LargeImage]()
    /// 点击了第几张图片
    var selectedIndex = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    /// 图片索引
    @IBOutlet weak var indexLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        indexLabel.text = "\(selectedIndex + 1)/\(images.count)"
        // 注册 cell。 这里直接用之前创建的 DongtaiCollectionViewCell。
        collectionView.register(UINib(nibName: String(describing: DongtaiCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: DongtaiCollectionViewCell.self))
        
        view.layoutIfNeeded()
        // 滑动到点击的那张图片。若不实现 view.layoutIfNeeded() ，这句代码不会起作用
        collectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    /// 图片保存按钮点击
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        let largeImage = images[selectedIndex]
        ImageDownloader.default.downloadImage(with: URL(string: largeImage.urlString)!, retrieveImageTask: nil, options: nil, progressBlock: { (receivedSize, totalSize) in
            let progress = Float(receivedSize) / Float(totalSize)
            SVProgressHUD.showProgress(progress)
            SVProgressHUD.setBackgroundColor(.black)
            SVProgressHUD.setForegroundColor(.white)
        }) { (image, error, cacheType, imageURL) in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image!)
            }, completionHandler: { (success, error) in
                SVProgressHUD.dismiss()
                if success {
                    SVProgressHUD.showSuccess(withStatus: "保存成功!")
                    // 延迟 1s
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                        SVProgressHUD.dismiss()
                    })
                } else {
                    SVProgressHUD.showError(withStatus: "保存失败!")
                    // 延迟 1s
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                        SVProgressHUD.dismiss()
                    })
                }
            })
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PreviewDongtaiLargeImageController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DongtaiCollectionViewCell.self), for: indexPath) as! DongtaiCollectionViewCell
        cell.largeImage = images[indexPath.item]
        cell.thumbImageView.contentMode = .scaleAspectFit
        cell.thumbImageView.layer.borderWidth = 0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        selectedIndex = Int(scrollView.contentOffset.x / collectionView.width + 0.5)
        indexLabel.text = "\(selectedIndex + 1)/\(images.count)"
    }
}
