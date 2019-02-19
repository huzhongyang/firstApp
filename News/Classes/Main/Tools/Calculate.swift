//
//  Calculate.swift
//  News
//
//  Created by huzhongyang on 2019/2/15.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import UIKit

protocol Calculatable {
    /// 计算高度
    static func detailCollectionViewHieght(_ thumbImages: [ThumbImage]) -> CGFloat
    /// 计算 collectionView 宽度
    static func collectionViewWidth(_ count: Int) -> CGFloat
    /// 计算 collectionView 高度
    static func collectionViewHeight(_ count: Int) -> CGFloat
    /// 计算 collectionViewCell 的大小
    static func collectionViewCellSize(_ count: Int) -> CGSize
    /// 计算文本的高度
    static func textHeight(text: String, fontSize: CGFloat, width: CGFloat) -> CGFloat
    /// 计算文本的宽度
    static func textWidth(text: String, fontSize: CGFloat, height: CGFloat) -> CGFloat
}

extension Calculatable {
    
    /// 计算高度
    static func detailCollectionViewHieght(_ thumbImages: [ThumbImage]) -> CGFloat {
        switch thumbImages.count {
        case 1:
            let thumbImage = thumbImages.first!
            return (screenWidth - 30) * thumbImage.height / thumbImage.width
        case 2: return (screenWidth - 35) * 0.5
        case 3: return image3Width + 5
        case 4: return (screenWidth - 3)
        case 5, 6: return (image3Width + 5) * 2
        case 7...9: return (image3Width + 5) * 3
        default: return 0
        }
    }
    
    /// 计算 collectionView 宽度
    static func collectionViewWidth(_ count: Int) -> CGFloat {
        switch count {
        case 1, 2: return (image2Width + 5) * 2
        case 3, 5...9: return screenWidth - 30
        case 4: return (image3Width + 5) * 2
        default: return 0
        }
    }
    /// 计算 collectionView 高度
    static func collectionViewHeight(_ count: Int) -> CGFloat {
        switch count {
        case 1, 2: return image2Width
        case 3: return image3Width + 5
        case 4...6: return (image3Width + 5) * 2
        case 7...9: return (image3Width + 5) * 3
        default: return 0
        }
    }
    
    /// 计算 collectionViewCell 的大小
    static func collectionViewCellSize(_ count: Int) -> CGSize {
        switch count {
        case 1, 2: return CGSize(width: image2Width, height: image2Width)
        case 3...9: return CGSize(width: image3Width, height: image3Width)
        default: return .zero
        }
    }
    
    /// 计算文本的高度
    static func textHeight(text: String, fontSize: CGFloat, width: CGFloat) -> CGFloat {
        return text.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size.height + 5
    }
    
    /// 计算文本的宽度
    static func textWidth(text: String, fontSize: CGFloat, height: CGFloat) -> CGFloat {
        return text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size.height
    }
}

struct Calculate: Calculatable { }