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
import BTNavigationDropdownMenu

class MainViewController: UIViewController {

    var tableView: UITableView!
    var startBtn: UIButton!
    var removeAllBtn: UIButton!
    var linkArray: [[String:String]] {
        get {
            return PlistManager.standard.array
        }
    }
    
    var isSuccessful = false
    var AFManager: SessionManager!
    let items = ["手动增加", "二维码扫描增加"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "bgNavi"), for: .default)
        self.navigationController?.navigationBar.shadowImage = #imageLiteral(resourceName: "line")
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "back"))
        
        let menu = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "添加帐号", items: items as [AnyObject] )
        self.navigationItem.titleView = menu
        menu.cellBackgroundColor = UIColor.colorFrom(hexString: "5A657A")
        menu.cellTextLabelColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        menu.cellSeparatorColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        menu.cellSelectionColor = UIColor.colorFrom(hexString: "515E7C")
        menu.checkMarkImage = nil
        menu.selectedCellTextLabelColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        menu.animationDuration = 0.3
        menu.cellTextLabelFont = UIFont.systemFont(ofSize: 16)
        menu.navigationBarTitleFont = UIFont.systemFont(ofSize: 17)
        menu.shouldChangeTitleText = false
        
        menu.didSelectItemAtIndexHandler = { [weak self] index in
            switch index {
            case 0:
                self?.present(AddViewController(), animated: true, completion: nil)
            default:
                self?.present(CameraViewController(), animated: true, completion: nil)
            }
        }
        
        
        // 导航栏右按钮
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushAddPage))
        
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
        tableView.backgroundColor = UIColor.clear
        tableView.frame = CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height)
        tableView.register(HomeCell.classForCoder(), forCellReuseIdentifier: "HomeCell")
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(10, 0, 74, 0)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        // 启动按钮
        startBtn = UIButton()
        startBtn.setBackgroundImage(#imageLiteral(resourceName: "fly"), for: .normal)
        view.addSubview(startBtn)
        startBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(Screen.width / 6)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        startBtn.layoutIfNeeded()
        startBtn.layer.cornerRadius = startBtn.s_width / 2
        startBtn.addTarget(self, action: #selector(getKey), for: .touchUpInside)
        
        // 清空按钮
//        removeAllBtn = UIButton()
//        startBtn.setBackgroundImage(nil, for: .normal)
//        view.addSubview(removeAllBtn)
//        removeAllBtn.snp.makeConstraints { (make) in
//            make.width.height.equalTo(<#T##other: ConstraintRelatableTarget##ConstraintRelatableTarget#>)
//        }
        
        if linkArray.count == 0 {
            startBtn.isEnabled = false
        }
        
    }
    
    /// 获取每小时变动的key
    func getKey() {
        AFManager.request("http://xzfuli.cn/#").responseString { (response) in
            
            switch response.result {
            case .success(let value):
//                print(value)
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
                    self.isSuccessful = true
                    self.tableView.reloadData()
                case .failure(let error):
                    print("post---\(error)")
                }
                
            })
        }
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
        startBtn.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isSuccessful = false
        tableView.reloadData()
        if linkArray.count > 0 {
            startBtn.isEnabled = true
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
