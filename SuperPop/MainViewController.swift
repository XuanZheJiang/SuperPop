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

class MainViewController: UIViewController {

    var tableView: UITableView!
    var startBtn: UIButton!
    
    var linkArray: [[String:String]] {
        get {
            return PlistManager.standard.array
        }
    }
    
    var isSuccessful = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.navigationItem.title = "球球辅助"
        // 导航栏右按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "增加", style: .plain, target: self, action: #selector(pushAddPage))
        
        // 初始化tableView
        tableView = UITableView()
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
    
    func getKey() {
        Alamofire.request("http://xzfuli.cn/#").responseData { (response) in
            let str = String.init(data: response.data!, encoding: .utf8)!
            
            let pattern = "key':'(.*)'"
            let result = str.match(pattern: pattern, index: 1)
            let resultFirst = result.first
            if let resultFirst = resultFirst {
                print("key=\(resultFirst)")
                self.startClick(key: resultFirst)
            }
        }
    }
    
    // 启动
    func startClick(key: String) {
        print(linkArray.count)
        
        for dict in linkArray {
            
            let parameters1 = ["type":"4", "url":dict["url"]! as String]
            Alamofire.request(postUrl, method: .post, parameters: parameters1, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                
                let jsonDic = try! JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String : Any];
                let code = jsonDic["code"] as! NSNumber
                let msg = jsonDic["msg"] as! String
                let url = jsonDic["url"] as! String
                print(code, msg, url)
            })
            
            let parameters2 = ["type":"2", "id":dict["id"]! as String, "key":key]
            Alamofire.request(postUrl, method: .post, parameters: parameters2, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                
                let jsonDic = try! JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String : Any];
                let code = jsonDic["code"] as! NSNumber
                let msg = jsonDic["msg"] as! String
                print(code, msg);
                
            })
            sleep(1)
        }
        self.isSuccessful = true
        tableView.reloadData()
    }
    
    
    
    // 导航到增加页
    func pushAddPage() {
        let addVC = AddViewController()
        self.navigationController?.pushViewController(addVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}
