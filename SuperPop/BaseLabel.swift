//
//  BaseLabel.swift
//  SuperPop
//
//  Created by JGCM on 2017/4/2.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressCopy(gesture:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(longPress)
        self.font = UIFont.systemFont(ofSize: 18)
        self.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func longPressCopy(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            let newX = gesture.location(in: self).x
            // 要使menu弹出来，必须 becomeFirstResponder
            self.becomeFirstResponder()
            let menuItems = UIMenuItem(title: "复制", action: #selector(self.coppy))
            UIMenuController.shared.menuItems = [menuItems]
            let rect = CGRect(x: newX, y: 5, width: 0, height: 0)
            UIMenuController.shared.setTargetRect(rect, in: self)
            UIMenuController.shared.setMenuVisible(true, animated: true)
        default:
            break
        }
    }
    
    func coppy() {
        let paste = UIPasteboard.general
        paste.string = self.text
    }
    
    // 要使menu弹出来，必须return true
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
