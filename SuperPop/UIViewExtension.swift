//
//  UIViewExtension.swift
//  JxzNewConfig
//
//  Created by xuanZheJiang on 12/5/16.
//  Copyright © 2016 xuanZheJiang. All rights reserved.
//

import UIKit

let SCREEN_W = UIScreen.main.bounds.size.width
let SCREEN_H = UIScreen.main.bounds.size.height

extension UIView {
    
    /// View的宽
    var s_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    /// View的高
    var s_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    /// View的Y点坐标 
    var s_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    /// View的X点坐标
    var s_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    /// View的底边界Y点坐标
    var s_bottom: CGFloat {
        get{
            return self.frame.maxY
        }
        set {
            self.frame.origin.y = newValue - s_height
        }
    }
    
    /// View的右边界X点坐标
    var s_trailing: CGFloat {
        get {
            return self.frame.maxX
        }
        set {
            self.frame.origin.x = newValue - s_width
        }
    }
    
}
