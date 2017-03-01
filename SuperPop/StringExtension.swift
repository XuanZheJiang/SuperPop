//
//  StringExtension.swift
//  SuperPop
//
//  Created by JGCM on 17/2/28.
//  Copyright © 2017年 JGCM. All rights reserved.
//
import Foundation

extension String {
    /// 获取匹配的字符串
    ///
    /// - Parameters:
    ///   - pattern: regular pattern
    ///   - index: index = 0 no capture, index = 1 the first capture, ...
    /// - Returns: matched strings
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
