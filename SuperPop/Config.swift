//
//  Config.swift
//  JxzNewConfig
//
//  Created by xuanZheJiang on 12/5/16.
//  Copyright © 2016 xuanZheJiang. All rights reserved.
//

import UIKit

let postUrl = "http://xzfuli.cn/index.php?a=api_qiuqiu"
let filePath = NSHomeDirectory() + "/Documents/profile.plist"
/// 常用路径
struct Path {
    static let documents = NSHomeDirectory() + "/Documents/"
    static let cache = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first ?? ""
    static let linkPath = Bundle.main.path(forResource: "link.plist", ofType: nil)!
}

/// 常用字体字号
struct Font {
    
    ///
    static let tiny: UIFont! = UIFont(name: "PingFangSC-Regular", size: 13) //why use "!"
    
}

/// 全局屏幕宽高和缩放比
struct Screen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let scale = UIScreen.main.scale
}

/// 全局通知名称
struct NotificationName {
    static let PlistCountZero = Notification.Name("PlistCountZero")
    static let PlistCountNonZero = Notification.Name("PlistCountNonZero")
}

/// 第三方开发平台 AppKey
struct AppKey {
    static let wechat = ""
}

/// 第三方开发平台 AppSecret
struct AppSecret {
    
}

