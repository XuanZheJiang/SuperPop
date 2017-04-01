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
struct POST {
    /// 获取棒棒糖
    static let postUrl = "http://xzfuli.cn/index.php?a=api_qiuqiu"
    /// 解析短链接
    static let shortUrl = "http://duanwangzhihuanyuan.51240.com/web_system/51240_com_www/system/file/duanwangzhihuanyuan/get/"
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
            countNumL.text = "\(array.count)个帐号"
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
        getKey()
    }
    
    /// 获取每小时变动的key
    func getKey() {
        
        Alamofire.request("http://xzfuli.cn/#").responseString { (response) in
            
            switch response.result {
            case .success(let value):
                let pattern = "key':'(.*)'"
                let keys = value.match(pattern: pattern, index: 1)
                let key = keys.first
                
                if let key = key {
                    self.startClick(key: key)
                }else {
                    self.activitySmall.stopAnimating()
                    self.flyBtn.isEnabled = true
                    self.logInfoL.text = "此时提交人数多，请稍后再试。"
                }
                
            case .failure(_):
//                print("getKey---\(error)")
                self.activitySmall.stopAnimating()
                self.flyBtn.isEnabled = true
                self.logInfoL.text = "网络超时"
            }
        }
    }
    
    // 启动
    func startClick(key: String) {
        
        for dict in arr {
            
            let parameters2 = ["type":"5", "id":dict["id"]! as String, "key":key]
            Alamofire.request(POST.postUrl, method: .post, parameters: parameters2, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let msg = json["msg"].stringValue
                    self.logInfoL.text = msg
                    self.activitySmall.stopAnimating()
                    self.flyBtn.isEnabled = true
                    self.flyBtn.setBackgroundImage(#imageLiteral(resourceName: "singleHook.png"), for: .normal)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: { 
                        self.flyBtn.setBackgroundImage(#imageLiteral(resourceName: "Newfly.png"), for: .normal)
                    })
                case .failure(_):
//                    print("post---\(error)")
                    self.flyBtn.isEnabled = true
                    self.activitySmall.stopAnimating()
                    self.logInfoL.text = "网络超时"
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
