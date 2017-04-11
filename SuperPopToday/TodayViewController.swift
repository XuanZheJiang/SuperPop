//
//  TodayViewController.swift
//  SuperPopToday
//
//  Created by JGCM on 2017/3/28.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire
import SwiftyJSON
import SnapKit

/// 网络请求
struct POSTToday {
    /// 获取棒棒糖
    static let newUrl = "http://www.qqgonglue.com/php/do.php?"
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

class TodayViewController: UIViewController, NCWidgetProviding {
   
    @IBOutlet weak var countNumL: UILabel!
    @IBOutlet weak var flyBtn: UIButton!
    @IBOutlet weak var logInfoL: UILabel!
    @IBOutlet weak var activitySmall: UIActivityIndicatorView!
    
    
    var arr: [[String:String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            
        } else {
            activitySmall.activityIndicatorViewStyle = .white
            countNumL.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            logInfoL.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.SuperPop")?.appendingPathComponent("profile.plist")
        if let array = NSArray(contentsOf: groupURL!) {
            countNumL.text = "\(array.count)条记录"
            flyBtn.isEnabled = true
            self.arr = array as! [[String : String]]
        }

    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
        
    @IBAction func flyAction(_ sender: UIButton) {
        
        guard arr.count > 0 else { return }
        self.activitySmall.startAnimating()
        self.logInfoL.text = ""
        self.flyBtn.isEnabled = false
        startClick()
    }
    
    // 启动
    func startClick() {
        
        for dict in arr {
            
            let parameters = ["url":dict["url"]!]
            Alamofire.request(POSTToday.newUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: POSTToday.headers).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    switch json["code"].intValue {
                    case 1:
                        self.logInfoL.text = "今天已提交\n请明日再来"
                    case 0:
                        self.logInfoL.text = "提交成功"
                    case -1:
                        self.logInfoL.text = "提交失败\n请稍后再试"
                    default:
                        self.logInfoL.text = "未知错误\n请稍后再试"
                    }
                    
                    self.activitySmall.stopAnimating()
                    self.flyBtn.setBackgroundImage(#imageLiteral(resourceName: "singleHook.png"), for: .normal)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                        self.flyBtn.setBackgroundImage(#imageLiteral(resourceName: "Newfly.png"), for: .normal)
                        self.flyBtn.isEnabled = true
                        self.logInfoL.text = ""
                    })
                case .failure( _):
                    self.flyBtn.isEnabled = true
                    self.activitySmall.stopAnimating()
                    self.logInfoL.text = "网络不太稳定,请稍后重试"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { 
                        self.logInfoL.text = ""
                    })
                }
                
            })
        }
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
//    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
//        
//        switch activeDisplayMode {
//        case .compact:
//            self.preferredContentSize = CGSize(width: 320, height: 110)
//        case .expanded:
//            self.preferredContentSize = CGSize(width: 320, height: 600)
//        }
//        
//    }
    
}

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.extensionContext?.widgetLargestAvailableDisplayMode = .compact
//    }

extension String {
    
    func match(pattern: String, index: Int = 0) -> [String] {
        let regex = try? NSRegularExpression.init(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let res = regex!.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count))
        var arr = [String]()
        for checkingRes in res {
            arr.append((self as NSString).substring(with: checkingRes.rangeAt(index)))
        }
        return arr
    }
}
