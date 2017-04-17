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
        DispatchQueue.global().async {
            for dict in self.arr {
                let group = DispatchGroup()
                group.enter()
                self.lollyRequest(dict: dict) {
                    group.leave()
                }
                group.enter()
                self.longDanRequest(dict: dict) {
                    group.leave()
                }
                group.wait()
            }
        }
    }
    
    func longDanRequest(dict: [String:String], callBack: @escaping () -> Void) {
        let parameters = ["url":dict["url"]!]
        Alamofire.request(POST.LongDanUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: POST.headers).responseJSON(completionHandler: { (response) in
            callBack()
        })
    }
    
    func lollyRequest(dict: [String:String], callBack: @escaping () -> Void) {
        let parameters = ["url":dict["url"]!]
        Alamofire.request(POST.newUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: POST.headers).responseJSON(completionHandler: { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                switch json["code"].intValue {
                case 1:
                    self.logInfoL.text = "今天已提交\n请明日再来"
                case 0:
                    self.logInfoL.text = "提交成功"
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
            callBack()
        })
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
