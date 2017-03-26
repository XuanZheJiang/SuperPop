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

    var lollyLinkTF: LinkTextField!
    var addBtn: AddLinkButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "back"))
        
        self.navigationItem.title = "增加帐号"
        
        // 导航栏右按钮
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相机", style: .plain, target: self, action: #selector(pushCameraPage))
        
        // 棒棒糖推广链接输入框
        lollyLinkTF = LinkTextField()
        lollyLinkTF.text = "http://t.cn/RtqVl3m"
        lollyLinkTF.placeholder = "请输入棒棒糖推广链接"
        view.addSubview(lollyLinkTF)
        lollyLinkTF.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
            make.width.equalTo(Screen.width - 40)
            make.height.equalTo(40)
        }
        
        // 增加按钮
        addBtn = AddLinkButton(type: .custom)
        addBtn.setTitle("增加", for: .normal)
        addBtn.addTarget(self, action: #selector(addAccount), for: .touchUpInside)
        view.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.lollyLinkTF.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        
    }
    
    func addAccount() {
        
        let parameters = ["turl":lollyLinkTF.text!]
        Alamofire.request("http://duanwangzhihuanyuan.51240.com/web_system/51240_com_www/system/file/duanwangzhihuanyuan/get/", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            let result = String.init(data: response.data!, encoding: .utf8)
//            print(response.result.value)
            var dict = [String:String]()
            
            // 取出id
            let pattern = "id=(\\d{6,10})"
            let id = result?.match(pattern: pattern, index: 1)
            if let id = id?.first {
                print("id=\(id)")
                dict["id"] = id
            }

            // 取出Account
            let pattern2 = "Account=(.*)\" target"
            let account = result?.match(pattern: pattern2, index: 1)
            if let account = account?.first {
                print("account=\(account.removingPercentEncoding)")
                dict["account"] = account.removingPercentEncoding
            }
            
            // 存入plist
            if dict.count == 2 {
                PlistManager.standard.array.append(dict)
                self.dismiss(animated: true, completion: nil)
            }else {
                print("推广链接有误")
                let failAlert = UIAlertController(title: "错误", message: "推广链接有误", preferredStyle: .alert)
                let failAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                failAlert.addAction(failAction)
                self.present(failAlert, animated: true, completion: nil)
            }
        }
        
    }
    
    func pushCameraPage() {
        let cameraVC = CameraViewController()
        self.navigationController?.pushViewController(cameraVC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}
