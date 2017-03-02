//
//  PlistManager.swift
//  SuperPop
//
//  Created by JGCM on 17/3/1.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import Foundation

class PlistManager {
    
    static let standard = PlistManager()
    var array: [[String:String]] {
        didSet {
            writePlist()
        }
    }
    
    private init() {
        array = NSArray(contentsOfFile: filePath) as? [[String:String]] ?? [[String:String]]()
    }
    
    private func writePlist() {
        (array as NSArray).write(toFile: filePath, atomically: true)
    }
    
    
    /// 清空plist
    func clear() {
        array.removeAll()
    }

}
