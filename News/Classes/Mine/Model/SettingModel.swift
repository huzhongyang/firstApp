//
//  SettingModel.swift
//  News
//
//  Created by huzhongyang on 2018/12/25.
//  Copyright © 2018 huzhongyang. All rights reserved.
//

import Foundation
import HandyJSON

struct SettingModel: HandyJSON {
    
    var title: String = ""
    var subtitle: String = ""
    var rightTitle: String = ""
    var isHiddenRightTitle: Bool = false
    var isHiddenSubtitle: Bool = false
    var isHiddenRightArrow: Bool = false
    var isHiddenSwitch: Bool = false

}
