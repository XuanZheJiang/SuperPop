//
//  AdddViewController.swift
//  SuperPop
//
//  Created by JGCM on 17/3/27.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit
import SnapKit

class AddViewController: UIViewController {
    
    var headerView: UIImageView!
    var dismissBtn: BaseButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.contents = #imageLiteral(resourceName: "back").cgImage
        
        // headerView
        headerView = UIImageView()
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(64)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(36)
        }
        
        // dismissBtn
        dismissBtn = BaseButton()
        dismissBtn.setImage(#imageLiteral(resourceName: "dismiss"), for: .normal)
        dismissBtn.addTarget(self, action: #selector(self.dismissAction), for: .touchUpInside)
        dismissBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        view.addSubview(dismissBtn)
        dismissBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.top.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }

}
