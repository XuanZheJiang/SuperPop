//
//  AddViewController.swift
//  SuperPop
//
//  Created by JGCM on 17/2/28.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import PKHUD

class InputCodeViewController: AddViewController {

    var carefulView: UIImageView!
    var lollyLinkTF: LinkTextField!
    var addBtn: BaseButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.image = #imageLiteral(resourceName: "headerT")
        self.headerView.frame.size.width = 125
        
        // 注意字样
        carefulView = UIImageView()
        carefulView.image = #imageLiteral(resourceName: "careful")
        view.addSubview(carefulView)
        carefulView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(64)
            make.centerX.equalToSuperview()
            make.width.equalTo(261)
            make.height.equalTo(53)
        }
        
        // 棒棒糖推广链接输入框
        lollyLinkTF = LinkTextField()
        #if DEBUG
        lollyLinkTF.text = "http://t.cn/RtqVl3m"
        #endif
        view.addSubview(lollyLinkTF)
        lollyLinkTF.snp.makeConstraints { (make) in
            make.top.equalTo(self.carefulView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        // 增加按钮
        addBtn = BaseButton()
        addBtn.setBackgroundImage(#imageLiteral(resourceName: "Hook"), for: .normal)
        addBtn.addTarget(self, action: #selector(addAccount), for: .touchUpInside)
        view.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(Screen.width / 6)
            make.top.equalTo(self.lollyLinkTF.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
    }
    
    
    
    func addAccount() {
        HUD.flash(.rotatingImage(#imageLiteral(resourceName: "lollyR")), delay: 30)
        
        let parameters = ["turl":lollyLinkTF.text!]
        Alamofire.request("http://duanwangzhihuanyuan.51240.com/web_system/51240_com_www/system/file/duanwangzhihuanyuan/get/", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            let result = String.init(data: response.data!, encoding: .utf8)
//            print(response.result.value)
            var dict = [String:String]()
            
            // 取出id
            let pattern = "id=(\\d{6,10})"
            let id = result?.match(pattern: pattern, index: 1)
            if let id = id?.first {
//                print("id=\(id)")
                dict["id"] = id
            }

            // 取出Account
            let pattern2 = "Account=(.*)\" target"
            let account = result?.match(pattern: pattern2, index: 1)
            if let account = account?.first {
//                print("account=\(account.removingPercentEncoding!)")
                dict["account"] = account.removingPercentEncoding
            }
            
            // 存入plist
            if dict.count == 2 {
                PlistManager.standard.array.append(dict)
                HUD.hide()
                self.dismiss(animated: true, completion: nil)
            }else {
                print("推广链接有误")
                HUD.hide()
                let failAlert = UIAlertController(title: "错误", message: "推广链接有误", preferredStyle: .alert)
                let failAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                failAlert.addAction(failAction)
                self.present(failAlert, animated: true, completion: nil)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
