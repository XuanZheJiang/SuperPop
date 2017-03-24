//
//  AddLinkButton.swift
//  SuperPop
//
//  Created by JGCM on 17/3/24.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit

class AddLinkButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        self.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        self.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
