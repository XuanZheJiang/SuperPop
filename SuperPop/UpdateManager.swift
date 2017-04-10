//
//  UpdateManager.swift
//  SuperPop
//
//  Created by JGCM on 2017/4/3.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import Foundation
import UIKit

class UpdateManager {
    
    private init() {}
    
    // 跳转到商店商品主页
    static func JumpToAppStore() {
        let url = "https://itunes.apple.com/us/app/rushtogo/id1221806149?l=zh&ls=1&mt=8"
        UIApplication.shared.openURL(URL.init(string: url)!)
    }
    
    // 跳转到商店商品评价页面
    static func evaluation() {
        let url = "itms-apps://itunes.apple.com/app/id1221806149?action=write-review"
        UIApplication.shared.openURL(URL.init(string: url)!)
    }
    
    
}
