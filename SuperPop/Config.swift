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
    static let newUrl = "http://www.qqgonglue.com/php/do.php?"
    /// 短链接还原
    static let shortUrl = "http://duanwangzhihuanyuan.51240.com/web_system/51240_com_www/system/file/duanwangzhihuanyuan/get/"
    /// 原链接变短
    static let changeShort = "http://www.alifeifei.net/index.php?m=index&a=urlCreate"
    /// 请求headers
    static let headers = ["Host":"www.qqgonglue.com",
                   "Accept-Encoding":"gzip, deflate",
                   "Cookie":"Hm_lvt_03223eb31e94b9d6eaa876f5f2f44de4=1491580229; CNZZDATA1260063679=1428465801-1491526360-http%253A%252F%252Fwww.qqgonglue.com%252F%7C1491878065; PHPSESSID=stcarm3250nhp768bp78v61gu7; Hm_lpvt_7315998b2390029b80ed93e1779211e2=1491879896; Hm_lvt_7315998b2390029b80ed93e1779211e2=1491526953,1491527447,1491561422,1491840295; UM_distinctid=15b45ef53b71f1-08f09280920d558-3f616948-fa000-15b45ef53b86f9; __cfduid=db8053a94dc46770bd9b3e395d1c18b201491526885",
                   "Connection":"keep-alive",
                   "Accept":"application/json, text/javascript, */*; q=0.01",
                   "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30",
                   // Referer此条有效
        "Referer":"http://www.qqgonglue.com/",
        "Accept-Language":"zh-cn",
        "X-Requested-With":"XMLHttpRequest"]
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

