//
//  HomeCell.swift
//  SuperPop
//
//  Created by JGCM on 17/2/28.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit
import SnapKit

enum HomeCellStatus {
    case `default`
    case successful
    case failure
}

class HomeCell: UITableViewCell {

    var accountL: UILabel!
    var statusImageView: UIImageView!
    
    var status: HomeCellStatus = .default {
        didSet {
            switch status {
            case .default:
                self.statusImageView.isHidden = true
            case .successful:
                self.statusImageView.isHidden = false
            case .failure:
                self.statusImageView.isHidden = true
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        // 帐号Label
        accountL = UILabel()
        contentView.addSubview(accountL)
        accountL.font = UIFont.systemFont(ofSize: 18)
        accountL.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        // status
        statusImageView = UIImageView()
        statusImageView.isHidden = true
        statusImageView.image = #imageLiteral(resourceName: "status")
        contentView.addSubview(statusImageView)
        statusImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(20)
        }
        statusImageView.layoutIfNeeded()
        statusImageView.layer.cornerRadius = 5
        statusImageView.layer.masksToBounds = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
