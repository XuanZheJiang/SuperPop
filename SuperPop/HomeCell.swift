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
    
    var containerViewImage: UIImageView!

    var accountL: UILabel!
    var lollyImageView: UIImageView!
    var eggImageView: UIImageView!
    
    var bgGroup = [#imageLiteral(resourceName: "bgRed"),
                   #imageLiteral(resourceName: "bgGreen"),
                   #imageLiteral(resourceName: "bgLightGreen"),
                   #imageLiteral(resourceName: "bgPurple"),
                   #imageLiteral(resourceName: "bgDarkPuple"),
                   #imageLiteral(resourceName: "bgGray"),
                   #imageLiteral(resourceName: "bgPink"),
                   #imageLiteral(resourceName: "bgYellow"),
                   #imageLiteral(resourceName: "bgLigntBlue")]
    let randomNum = arc4random_uniform(9)
    
    var status: HomeCellStatus = .default {
        didSet {
            switch status {
            case .default:
                self.lollyImageView.isHidden = true
                self.eggImageView.isHidden = true
            case .successful:
                self.lollyImageView.isHidden = false
                self.eggImageView.isHidden = false
            case .failure:
                self.lollyImageView.isHidden = true
                self.eggImageView.isHidden = true
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        // containerView
        containerViewImage = UIImageView()
        containerViewImage.isUserInteractionEnabled = true
        containerViewImage.image = bgGroup[Int(randomNum)]
        contentView.addSubview(containerViewImage)
        containerViewImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-20)
        }
        
        
        // 帐号Label
        accountL = BaseLabel()
        containerViewImage.addSubview(accountL)
        accountL.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(50)
            make.centerY.equalToSuperview().offset(-2)
            make.height.equalTo(40)
        }
        
        // lolly
        lollyImageView = UIImageView()
        lollyImageView.image = #imageLiteral(resourceName: "lolly")
        containerViewImage.addSubview(lollyImageView)
        lollyImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.centerY.equalToSuperview()
            make.left.equalTo(self.accountL.snp.right).offset(10)
        }
        
        // egg
        eggImageView = UIImageView()
        eggImageView.image = #imageLiteral(resourceName: "egg")
        containerViewImage.addSubview(eggImageView)
        eggImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.centerY.equalToSuperview()
            make.left.equalTo(self.lollyImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        
    }
    
    func initWith(_ index: IndexPath, _ status: Bool) {
        self.accountL.text = PlistManager.standard.array[index.row]["account"]
        if status {
            self.status = .successful
        } else {
            self.status = .failure
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
