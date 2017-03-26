//
//  UIColorExtension.swift
//  JxzNewConfig
//
//  Created by xuanZheJiang on 12/5/16.
//  Copyright © 2016 xuanZheJiang. All rights reserved.
//

import UIKit

extension UIColor {
    static func colorFrom(hexString: String) -> UIColor {
        var hexInt: UInt32 = 0 //why use UInt32
        let scanner = Scanner(string: hexString)
        scanner.scanHexInt32(&hexInt) //why use pointter
        let color = UIColor (
            red: CGFloat((hexInt & 0xFF0000) >> 16) / 255,
            green: CGFloat((hexInt & 0xFF00) >> 8) / 255,
            blue: CGFloat(hexInt & 0xFF) / 255,
            alpha: 1)
        return color
    }
    
    static func colorFrom(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        let color = UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
        return color
    }

}



