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

class MainViewController: UIViewController {

    var tableView: UITableView!
    var startBtn: UIButton!
    var linkArray: [[String:String]] {
        get {
            return PlistManager.standard.array
        }
    }
    
    var isSuccessful = false
    var AFManager: SessionManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "球球辅助"
        // 导航栏右按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushAddPage))
        
        // 导航栏左按钮
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "清空", style: .plain, target: self, action: #selector(clear))
        
        // 配置超时config
        let configTimeout = URLSessionConfiguration.default
        configTimeout.timeoutIntervalForRequest = 3
        AFManager = SessionManager(configuration: configTimeout)
        
        // 初始化tableView
        tableView = UITableView()
        // 去掉tableView多余的空白行分割线
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "back"))
        tableView.frame = CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height)
        tableView.register(HomeCell.classForCoder(), forCellReuseIdentifier: "HomeCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        // 启动按钮
        startBtn = UIButton(type: .custom)
        startBtn.setTitleColor(UIColor.white, for: .normal)
        startBtn.setTitle("启动", for: .normal)
        startBtn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        view.addSubview(startBtn)
        startBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(Screen.width / 6)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        startBtn.layoutIfNeeded()
        startBtn.layer.cornerRadius = startBtn.s_width / 2
        startBtn.addTarget(self, action: #selector(getKey), for: .touchUpInside)
        
        if linkArray.count == 0 {
            startBtn.backgroundColor = UIColor.gray
            startBtn.isEnabled = false
        }
        
    }
    
    /// 获取每小时变动的key
    func getKey() {
        AFManager.request("http://xzfuli.cn/#").responseString { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                let pattern = "key':'(.*)'"
                let keys = value.match(pattern: pattern, index: 1)
                let key = keys.first
                
                if let key = key {
                    self.startClick(key: key)
                }
            case .failure(let error):
                print("getKey---\(error)")
                let failAlert = UIAlertController(title: "错误", message: "网络超时", preferredStyle: .alert)
                let failAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                failAlert.addAction(failAction)
                self.present(failAlert, animated: true, completion: nil)
            }
        }
    }
    
    // 启动
    func startClick(key: String) {
        
        for dict in linkArray {
            
            let parameters2 = ["type":"5", "id":dict["id"]! as String, "key":key]
            AFManager.request(postUrl, method: .post, parameters: parameters2, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                case .failure(let error):
                    print("post---\(error)")
                }
                
            })
        }
        self.isSuccessful = true
        tableView.reloadData()
    }
    
    
    
    // 导航到增加页
    func pushAddPage() {
        let addVC = AddViewController()
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    
    // 清空plist
    func clear() {
        PlistManager.standard.clear()
        tableView.reloadData()
        startBtn.backgroundColor = UIColor.gray
        startBtn.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isSuccessful = false
        tableView.reloadData()
        if linkArray.count > 0 {
            startBtn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            startBtn.isEnabled = true
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return linkArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.accountL.text = linkArray[indexPath.row]["account"]
        
        if isSuccessful {
            cell.status = .successful
        } else {
            cell.status = .failure
        }
        
        return cell
    }
    
    /// 左划删除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        PlistManager.standard.array.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    /// 修改Delete按钮文字为"删除"
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    
}
