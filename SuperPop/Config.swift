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
    static let newUrl = "http://api.cn-wolf.cn/Edition/BattleOfBalls/API/"
    /// 获取龙蛋
    static let LongDanUrl = "http://api.cn-wolf.cn/Edition/BattleOfBalls/API/ld.php?"
    /// 短链接还原
    static let shortUrl = "http://duanwangzhihuanyuan.51240.com/web_system/51240_com_www/system/file/duanwangzhihuanyuan/get/"
    /// 原链接变短
    static let changeShort = "http://dwz.cn/create.php"
    /// 请求headers
    static let headers = ["Host":"api.cn-wolf.cn",
                          "Origin":"http://www.000wl.cn",
                          "Accept-Encoding":"gzip, deflate",
                          "Connection":"keep-alive",
                          "Accept":"application/json, text/javascript, */*; q=0.01",
                          "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30",
                          "Referer":"http://www.000wl.cn/",
                          "Accept-Language":"zh-cn"]
    
    static let xzfuliHeaders = ["":"",
                                "":""]
}

/// 常用颜色
struct Color {
    /// 主灰色
    static let naviColor = UIColor.colorFrom(hexString: "5B667B")
}

/// 常用路径
struct Path {
    /// 共享空间
    static let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.SuperPop")?.appendingPathComponent("profile.plist")
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

