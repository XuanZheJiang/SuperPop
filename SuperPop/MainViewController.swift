//
//  ViewController.swift
//  SuperPop
//
//  Created by JGCM on 17/2/28.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import PKHUD

class MainViewController: BaseViewController {

    var tableView: BaseTableView!
    var startBtn: BaseButton!
    var removeAllBtn: BaseButton!
    
    var isSuccessful = false
    var AFManager: SessionManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 配置超时config
        let configTimeout = URLSessionConfiguration.default
        configTimeout.timeoutIntervalForRequest = 15
        AFManager = SessionManager(configuration: configTimeout)
        
        // 初始化tableView
        tableView = BaseTableView()
        tableView.frame = CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height)
        tableView.register(HomeCell.classForCoder(), forCellReuseIdentifier: "HomeCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        // 启动按钮
        startBtn = BaseButton()
        startBtn.setBackgroundImage(#imageLiteral(resourceName: "Newfly"), for: .normal)
        startBtn.addTarget(self, action: #selector(getKey), for: .touchUpInside)
        view.addSubview(startBtn)
        startBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(Screen.width / 6)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        // 清空按钮
        removeAllBtn = BaseButton()
        removeAllBtn.setBackgroundImage(#imageLiteral(resourceName: "NewdeleteAll"), for: .normal)
        removeAllBtn.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        removeAllBtn.transform = CGAffineTransform.identity
        
        view.addSubview(removeAllBtn)
        removeAllBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(Screen.width / 6)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }

        
    }

    // 清空plist
    func clearAll() {
        PlistManager.standard.clear()
        noCountImageView.isHidden = false
        startBtn.isEnabled = false
        removeAllBtn.isEnabled = false
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if PlistManager.standard.array.count > 0 {
            noCountImageView.isHidden = true
            startBtn.isEnabled = true
            removeAllBtn.isEnabled = true
        }else {
            noCountImageView.isHidden = false
            startBtn.isEnabled = false
            removeAllBtn.isEnabled = false
        }
        
        self.isSuccessful = false
        tableView.reloadData()
    }

    /// 获取每小时变动的key
    func getKey() {
        HUD.flash(.rotatingImage(#imageLiteral(resourceName: "lollyR")), delay: 15)
        
        AFManager.request("http://xzfuli.cn/#").responseString { (response) in
            
            switch response.result {
            case .success(let value):
//                print(value)
                let pattern = "key':'(.*)'"
                let keys = value.match(pattern: pattern, index: 1)
                let key = keys.first
                
                if let key = key {
                    self.startClick(key: key)
//                    print("key = \(key)")
                }else {
                    HUD.hide()
                    let failAlert = UIAlertController(title: "提示", message: "网站升级中...", preferredStyle: .alert)
                    let failAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    failAlert.addAction(failAction)
                    self.present(failAlert, animated: true, completion: nil)
                }
            case .failure(_):
//                print("getKey---\(error)")
                HUD.hide()
                let failAlert = UIAlertController(title: "错误", message: "网络超时", preferredStyle: .alert)
                let failAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                failAlert.addAction(failAction)
                self.present(failAlert, animated: true, completion: nil)
            }
        }
    }
    
    // 启动
    func startClick(key: String) {
        
        for dict in PlistManager.standard.array {
            
            let parameters2 = ["type":"5", "id":dict["id"]! as String, "key":key]
            AFManager.request(POST.postUrl, method: .post, parameters: parameters2, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    print(json)
                    
                    HUD.hide({ (value) in
//                        print(value)
                        HUD.flash(.label(json["msg"].stringValue), delay: 1.5)
                    })
                    self.isSuccessful = true
                    
                    self.tableView.reloadData()
                case .failure(_):
//                    print("post---\(error)")
                    let failAlert = UIAlertController(title: "错误", message: "网络超时", preferredStyle: .alert)
                    let failAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    failAlert.addAction(failAction)
                    self.present(failAlert, animated: true, completion: nil)
                }
                
            })
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlistManager.standard.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.accountL.text = PlistManager.standard.array[indexPath.row]["account"]
        
        if isSuccessful {
            cell.status = .successful
        } else {
            cell.status = .failure
        }
        
        return cell
    }
    
    // 左划删除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        PlistManager.standard.array.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        if PlistManager.standard.array.count == 0 {
            noCountImageView.isHidden = false
            startBtn.isEnabled = false
            removeAllBtn.isEnabled = false
        }
    }
    // 修改Delete按钮文字为"删除"
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    
}


