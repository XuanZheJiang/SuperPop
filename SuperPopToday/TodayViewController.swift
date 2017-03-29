//
//  TodayViewController.swift
//  SuperPopToday
//
//  Created by JGCM on 2017/3/28.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
   
    @IBOutlet weak var countNumL: UILabel!
    @IBOutlet weak var flyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.SuperPop")?.appendingPathComponent("profile.plist")
        if let array = NSArray(contentsOf: groupURL!) {
            countNumL.text = "\(array.count)个帐号"
//            print(array.count)
        }
        
        
        
    }
    
    @IBAction func flyAction(_ sender: UIButton) {
        flyBtn.setBackgroundImage(UIImage(named: "Hook"), for: .normal)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.extensionContext?.widgetLargestAvailableDisplayMode = .compact
//    }
    
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
