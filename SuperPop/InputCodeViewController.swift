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
import Fuzi
import Device

class InputCodeViewController: AddViewController {

    var nameTF: LinkTextField!
    var lollyLinkTF: LinkTextField!
    var addBtn: BaseButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.image = #imageLiteral(resourceName: "headerT")
        self.headerView.frame.size.width = 125
        
        // 备注
        nameTF = LinkTextField()
        nameTF.placeholder = "备注名称(选填)"
        nameTF.addTarget(self, action: #selector(self.textChange), for: .editingChanged)
        view.addSubview(nameTF)
        nameTF.snp.makeConstraints { (make) in
            if Device.size() == Size.screen4Inch {
                make.top.equalTo(self.headerView.snp.bottom).offset(30)
            }else {
                make.top.equalTo(self.headerView.snp.bottom).offset(64)
            }
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        // 棒棒糖推广链接输入框
        lollyLinkTF = LinkTextField()
        lollyLinkTF.keyboardType = .asciiCapable
        lollyLinkTF.addTarget(self, action: #selector(self.textChange), for: .editingChanged)
        view.addSubview(lollyLinkTF)
        lollyLinkTF.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameTF.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        // 增加按钮
        addBtn = BaseButton()
        addBtn.isEnabled = false
        addBtn.setBackgroundImage(#imageLiteral(resourceName: "Hook"), for: .normal)
        addBtn.addTarget(self, action: #selector(addAccount), for: .touchUpInside)
        view.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(Screen.width / 6)
            if Device.size() == Size.screen4Inch {
                make.top.equalTo(self.lollyLinkTF.snp.bottom).offset(10)
            }else {
                make.top.equalTo(self.lollyLinkTF.snp.bottom).offset(50)
            }
            make.centerX.equalToSuperview()
        }
        
    }
    
    // 密码输入框文字监听
    func textChange() -> Void {
        if lollyLinkTF.text!.characters.count > 15 && nameTF.text!.characters.count > 0 {
            addBtn.isEnabled = true
        } else {
            addBtn.isEnabled = false
        }
    }
    
    func addAccount() {
        view.endEditing(true)
        HUD.flash(.rotatingImage(#imageLiteral(resourceName: "lollyR")), delay: 10)
        
        let parameters = ["turl":lollyLinkTF.text!]
        Alamofire.request(POST.shortUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseString { (response) in
            
            switch response.result {
            case .success(let value):
                do {
                    let doc = try HTMLDocument(string: value)
                    if let ele = doc.firstChild(css: "a") {
                        self.save(url: ele.stringValue)
                    }else {
                        HUD.hide()
                        let failAlert = UIAlertController(title: "错误", message: "推广链接有误", preferredStyle: .alert)
                        let failAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        failAlert.addAction(failAction)
                        self.present(failAlert, animated: true, completion: nil)
                    }
                }catch {
                    HUD.hide()
                    let failAlert = UIAlertController(title: "错误", message: "解析失败请重试", preferredStyle: .alert)
                    let failAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    failAlert.addAction(failAction)
                    self.present(failAlert, animated: true, completion: nil)
                }
                
            case .failure(_):
                HUD.hide()
                let failAlert = UIAlertController(title: "错误", message: "启动失败请重试", preferredStyle: .alert)
                let failAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                failAlert.addAction(failAction)
                self.present(failAlert, animated: true, completion: nil)
            }
            
        }
        
    }
    
    func save(url: String?) {
        var dict = [String:String]()
        dict["url"] = lollyLinkTF.text
        dict["name"] = nameTF.text
        // 取出id
        let pattern = "id=(\\d{6,10})"
        let id = url?.match(pattern: pattern, index: 1)
        if let id = id?.first {
//            print("id=\(id)")
            dict["id"] = id
        }
        
        // 取出Account
        let pattern2 = "Account=(.*)"
        let account = url?.match(pattern: pattern2, index: 1)
        if let account = account?.first {
//            print("account=\(account.removingPercentEncoding!)")
            dict["account"] = account.removingPercentEncoding
        }
        
        // 存入plist
        if dict.count == 4 {
            PlistManager.standard.array.append(dict)
            HUD.hide()
            self.dismiss(animated: true, completion: nil)
        }else {
            HUD.hide()
            let failAlert = UIAlertController(title: "错误", message: "推广链接有误", preferredStyle: .alert)
            let failAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            failAlert.addAction(failAction)
            self.present(failAlert, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
