//
//  LinkTextField.swift
//  SuperPop
//
//  Created by JGCM on 17/3/24.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit

class LinkTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clearButtonMode = .whileEditing
        self.font = UIFont.systemFont(ofSize: 18)
        self.placeholder = "棒棒糖推广链接"
        self.textColor = UIColor.colorFrom(hexString: "637291")
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.background = #imageLiteral(resourceName: "bgTF")
    }
    
    // 修改placeholder的起始位置
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 15, y: bounds.origin.y, width: bounds.size.width - 15, height: bounds.size.height)
    }
    // 修改显示文本的起始位置
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 15, y: bounds.origin.y - 2, width: bounds.size.width - 15, height: bounds.size.height)
    }
    // 修改编辑时的起始位置
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 15, y: bounds.origin.y - 2, width: bounds.size.width - 15, height: bounds.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
