//
//  DeviceInfoManager.swift
//  SuperPop
//
//  Created by JGCM on 2017/3/30.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import Foundation
import Device
import CoreTelephony
import ReachabilitySwift

class DeviceInfoManager {

    static let `default` = DeviceInfoManager()
    
    fileprivate init() { }
    
    fileprivate let appName = "SLPop"
    fileprivate let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "appVersionIsNil"
    fileprivate let osVersion = UIDevice.current.systemVersion
    fileprivate let language = Locale.current.identifier
    fileprivate let timeZone = TimeZone.current.abbreviation() ?? "timeZoneIsNil"
    fileprivate let carrier = CTTelephonyNetworkInfo().subscriberCellularProvider?.carrierName ?? "carrierIsNil"
    
    fileprivate var deviceVersion: String {
        switch Device.version() {
        case .iPhone4:
            return "iPhone4"
        case .iPhone4S:
            return "iPhone4S"
        case .iPhone5:
            return "iPhone5"
        case .iPhone5C:
            return "iPhone5C"
        case .iPhone5S:
            return "iPhone5S"
        case .iPhoneSE:
            return "iPhoneSE"
        case .iPhone6:
            return "iPhone6"
        case .iPhone6Plus:
            return "iPhone6Plus"
        case .iPhone6S:
            return "iPhone6S"
        case .iPhone6SPlus:
            return "iPhone6SPlus"
        case .iPhone7:
            return "iPhone7"
        case .iPhone7Plus:
            return "iPhone7Plus"
        case .iPodTouch4Gen:
            return "iPodTouch4Gen"
        case .iPodTouch5Gen:
            return "iPodTouch5Gen"
        case .iPodTouch6Gen:
            return "iPodTouch6Gen"
        default:
            return "unknownDevice"
        }
        
    }
    
    var device: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    var netWork: String {
        return Reachability()?.currentReachabilityString ?? "knownNetwork"
    }
    
    // 生成用户设备详细信息
    func toFormat() -> String {
        let info = "appName: \(appName)\n" + "appVersion: \(appVersion)\n" + "osVersion: \(osVersion)\n\n" + "deviceVersion: \(deviceVersion)\n" + "device: \(device)\n" + "language: \(language)\n" + "timeZone: \(timeZone)\n" + "carrier: \(carrier)\n" + "netWork: \(netWork)\n"
        return info
    }
    
}
