//
//  RefreshView.swift
//  News
//
//  Created by huzhongyang on 2019/3/3.
//  Copyright © 2019 huzhongyang. All rights reserved.
//

import MJRefresh

class RefreshAutoGifFooter: MJRefreshAutoGifFooter {
    /// 初始化
    override func prepare() {
        super.prepare()
        // 设置控件的高度
        mj_h = 50
        // 图片数组
        var images = [UIImage]()
        for index in 0..<8 {
            let image = UIImage(named: "sendloading_18x18_\(index)")
            images.append(image!)
        }
        // 设置空闲状态的图片
        setImages(images, for: .idle)
        // 设置刷新状态的图片
        setImages(images, for: .refreshing)
        setTitle("上拉加载数据", for: .idle)
        setTitle("正在努力加载", for: .pulling)
        setTitle("正在努力加载", for: .refreshing)
        setTitle("没有更多数据啦", for: .noMoreData)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        gifView.x = 135
        gifView.centerY = stateLabel.centerY
    }
}
