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

class AddViewController: UIViewController {

    var shareLinkTF: UITextField!
    var addBtn: UIButton!
    var lineImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "增加帐号"
        
        // 导航栏右按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相机", style: .plain, target: self, action: #selector(pushCameraPage))
        
        // 推广链接输入框
        shareLinkTF = UITextField()
        shareLinkTF.text = "http://dwz.cn/2KzNUw"
        shareLinkTF.placeholder = "请输入推广链接"
        shareLinkTF.font = UIFont.systemFont(ofSize: 20)
        shareLinkTF.autocorrectionType = .no
        shareLinkTF.autocapitalizationType = .none
        view.addSubview(shareLinkTF)
        shareLinkTF.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
            make.width.equalTo(Screen.width - 40)
            make.height.equalTo(40)
        }
        
        // 输入框底线
        lineImageView = UIImageView()
        lineImageView.image = #imageLiteral(resourceName: "line")
        view.addSubview(lineImageView)
        lineImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.shareLinkTF)
            make.bottom.equalTo(self.shareLinkTF)
            make.height.equalTo(1)
            make.width.equalTo(self.shareLinkTF)
        }
        
        // 增加按钮
        addBtn = UIButton(type: .custom)
        addBtn.layer.cornerRadius = 5
        addBtn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        addBtn.setTitle("增加", for: .normal)
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        addBtn.setTitleColor(UIColor.white, for: .normal)
        addBtn.addTarget(self, action: #selector(addAccount), for: .touchUpInside)
        view.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.shareLinkTF.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        
    }
    
    func addAccount() {
        
        let parameters = ["turl":shareLinkTF.text!]
        Alamofire.request("http://duanwangzhihuanyuan.51240.com/web_system/51240_com_www/system/file/duanwangzhihuanyuan/get/", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            
            let result = String.init(data: response.data!, encoding: .utf8)
            
            // 取出id
            let pattern = "id=(\\d{6,10})"
            let id = result!.match(pattern: pattern, index: 1)
            print("id=\(id.first!)")

            // 取出Account
            let pattern2 = "Account=(.*)\" target"
            let account = result!.match(pattern: pattern2, index: 1)
            print("account=\(account.first!)")
            
            // 存入plist
            let dict = ["url":self.shareLinkTF.text!, "id":id.first!, "account":account.first!]
            PlistManager.standard.array.append(dict)
        }
        
    }
    
    
    func pushCameraPage() {
        let cameraVC = CameraViewController()
        self.navigationController?.pushViewController(cameraVC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
