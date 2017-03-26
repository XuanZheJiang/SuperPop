//
//  LinkTextField.swift
//  SuperPop
//
//  Created by JGCM on 17/3/24.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit
import SnapKit

class LinkTextField: UITextField {

    var lineImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clearButtonMode = .whileEditing
        self.font = UIFont.systemFont(ofSize: 18)
        self.textColor = UIColor.white
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        // 输入框底线
        lineImageView = UIImageView()
        lineImageView.image = #imageLiteral(resourceName: "line")
        self.addSubview(lineImageView)
        lineImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(1)
            make.width.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
