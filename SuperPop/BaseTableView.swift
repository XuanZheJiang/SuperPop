//
//  BaseTableView.swift
//  SuperPop
//
//  Created by JGCM on 2017/3/28.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit

class BaseTableView: UITableView {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        // 去掉tableView多余的空白行分割线
        self.tableFooterView = UIView()
        self.backgroundColor = UIColor.clear
        self.separatorStyle = .none
        self.contentInset = UIEdgeInsetsMake(10, 0, 74, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
