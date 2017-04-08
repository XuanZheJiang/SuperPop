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
    static let newUrl = "http://www.qqgonglue.com/"
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
            
            let parameters = ["c_href":dict["url"]!, "POST":"一键领取5个棒棒糖和30个龙蛋"]
            Alamofire.request(POSTToday.newUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseString(completionHandler: { (response) in
                
                switch response.result {
                case .success( _):
                    self.logInfoL.text = "成功"
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
