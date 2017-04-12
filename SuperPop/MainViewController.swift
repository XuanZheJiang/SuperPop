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
        configTimeout.timeoutIntervalForRequest = 30
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
        startBtn.addTarget(self, action: #selector(startClick), for: .touchUpInside)
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
        
        let alert = UIAlertController(title: "警告", message: "确定清空所有记录？", preferredStyle: .alert)
        let cancle = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "确定", style: .destructive) { (action) in
            PlistManager.standard.clear()
            self.noCountImageView.isHidden = false
            self.startBtn.isEnabled = false
            self.removeAllBtn.isEnabled = false
            self.tableView.reloadData()
        }
        alert.addAction(cancle)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
    
    // 启动
    func startClick() {
        HUD.flash(.rotatingImage(#imageLiteral(resourceName: "lollyR")), delay: 30)
        
        for dict in PlistManager.standard.array {
            
            let parameters = ["url":dict["url"]!]
            AFManager.request(POST.newUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: POST.headers).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(let value):
                    HUD.hide({ ( _) in
                        let json = JSON(value)
                        switch json["code"].intValue {
                        case 1:
                            HUD.flash(.label("今天已提交\n请明日再来"), delay: 1.0)
                        case 0:
                            HUD.flash(.label("提交成功"), delay: 1.0)
                        case -1:
                            HUD.flash(.label("提交失败\n请稍后再试"), delay: 1.0)
                        default:
                            HUD.flash(.label("未知错误\n请稍后再试"), delay: 1.0)
                        }
                    })
                    self.isSuccessful = true
                    self.tableView.reloadData()
                case .failure( _):
                    HUD.hide()
                    let failAlert = UIAlertController(title: "错误", message: "网络不太稳定,请稍后重试", preferredStyle: .alert)
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


