//
//  AddLinkButton.swift
//  SuperPop
//
//  Created by JGCM on 17/3/24.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit

class BaseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
//    func point(inside point: CGPoint, withEvent event: UIEvent) -> Bool {
//        var bounds: CGRect = self.bounds
//        //若原热区小于44x44，则放大热区，否则保持原大小不变
//        var widthDelta: CGFloat = max(44.0 - bounds.size.width, 0)
//        var heightDelta: CGFloat = max(44.0 - bounds.size.height, 0)
//        bounds = bounds.insetBy(dx: CGFloat(-0.5 * widthDelta), dy: CGFloat(-0.5 * heightDelta))
//        return bounds.contains(point)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
