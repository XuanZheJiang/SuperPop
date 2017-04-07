//
//  Config.swift
//  JxzNewConfig
//
//  Created by xuanZheJiang on 12/5/16.
//  Copyright © 2016 xuanZheJiang. All rights reserved.
//

import UIKit

/// 网络请求
struct POST {
    /// 获取棒棒糖
    static let postUrl = "http://xzfuli.cn/index.php?a=api_qiuqiu"
    static let newUrl = "http://www.pipaw.com/www/helperapi/ajax"
    /// 解析短链接
    static let shortUrl = "http://duanwangzhihuanyuan.51240.com/web_system/51240_com_www/system/file/duanwangzhihuanyuan/get/"
}

struct Color {
    static let naviColor = UIColor.colorFrom(hexString: "5B667B")
}

/// 常用路径
struct Path {
    static let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.SuperPop")?.appendingPathComponent("profile.plist")
//    static let doc = NSHomeDirectory().appending("/Documents/profile.plist")
    static let doc = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("p.plist")
}

/// 常用字体字号
struct Font {
    static let tiny: UIFont! = UIFont(name: "PingFangSC-Regular", size: 13)
    
}

/// 全局屏幕宽高和缩放比
struct Screen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let scale = UIScreen.main.scale
}

/// 全局通知名称
//struct NotificationName {
//    static let PlistCountZero = Notification.Name("PlistCountZero")
//    static let PlistCountNonZero = Notification.Name("PlistCountNonZero")
//}

/// 第三方开发平台 AppKey
struct AppKey {
    /// 极光推送
    static let JPush = "313d9d29c51b39da1fc1d75d"
}

