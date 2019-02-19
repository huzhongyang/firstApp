//
//  Const.swift
//  News
//
//  Created by huzhongyang on 2018/11/19.
//  Copyright © 2018 huzhongyang. All rights reserved.
//

import UIKit

/// 屏幕的宽度
let screenWidth = UIScreen.main.bounds.width

/// 屏幕的高度
let screenHeight = UIScreen.main.bounds.height

/// 服务器地址
//let BASE_URL = "http://lf.snssdk.com"
//let BASE_URL = "http://id.snssdk.com"
let BASE_URL = "https://is.snssdk.com"

let device_id: Int = 6096495334
let iid: Int = 5034850950

/// mine 顶部视图高度
let mineHeaderViewHeight: CGFloat = 280

let userDetailHeaderBGImageViewHeight: CGFloat = 146


let isNight = "isNight"

let isIPhoneX: Bool = screenHeight == 812 ? true : false

/// 关注的用户详情界面 topTab 的按钮的 宽度
let topTabButtonWidth: CGFloat = screenWidth * 0.2

/// 关注的用户详情界面 topTab 的指示条的 宽度 和 高度
let topTabindicatorWidth: CGFloat = 40
let topTabindicatorHeight: CGFloat = 2

/// 动态图片的宽高
// 图片的宽高
// 1          screenWidth * 0.5
// 2          (screenWidth - 35) / 2
// 3,4,5-9    (screenWidth - 40) / 3
let image1Width: CGFloat = screenWidth * 0.5
let image2Width: CGFloat = (screenWidth - 35) * 0.5
let image3Width: CGFloat = (screenWidth - 40) / 3