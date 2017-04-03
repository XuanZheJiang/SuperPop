//
//  AppDelegate.swift
//  SuperPop
//
//  Created by JGCM on 17/2/28.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let mainNC = UINavigationController(rootViewController: MainViewController())
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.backgroundColor = UIColor.white
        window?.rootViewController = mainNC
        window?.makeKeyAndVisible()
        
        // 注册极光推送
        JPUSHService.register(forRemoteNotificationTypes: UIUserNotificationType.alert.rawValue | UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue, categories: nil)
        JPUSHService.setup(withOption: launchOptions, appKey: AppKey.JPush, channel: "AppStore", apsForProduction: true)
        
        // 监听极光自定义消息推送
        NotificationCenter.default.addObserver(self, selector: #selector(networkDidReceiveMessage(notifi:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
        #if DEBUG
        #else
            JPUSHService.setLogOFF()
        #endif
        return true
    }
    
    // 处理极光自定义消息推送
    func networkDidReceiveMessage(notifi: Notification) {
        
        if let content = notifi.userInfo?["content"] as? String, let extras = notifi.userInfo?["extras"] as? NSDictionary {
            let alert = UIAlertController(title: extras["title"] as? String ?? "通知", message: content, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    // 从APNs获取deviceToken上传到极光
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    // 处理APNs消息
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)

        let alert = UIAlertController(title: "🎉版本更新", message: "不去看看有什么新功能吗？", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "没兴趣", style: .cancel, handler: nil)
        let determine = UIAlertAction(title: "看看呗", style: .default) { (alert) in
            // 不用延时会警告"_BSMachError: port 9403"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                UpdateManager.JumpToAppStore()
            })
        }
        alert.addAction(cancel)
        alert.addAction(determine)
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        completionHandler(.newData)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        JPUSHService.resetBadge()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }
}
