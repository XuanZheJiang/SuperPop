//
//  FeedbackViewController.swift
//  SuperPop
//
//  Created by JGCM on 2017/4/4.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit
import SnapKit
import Device

class FeedbackViewController: AddViewController {

    var feedbackTextView: UITextView!
    var addBtn: BaseButton!
    var numberL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.headerView.image = #imageLiteral(resourceName: "feedback")
        self.headerView.frame.size.width = 125
        
        feedbackTextView = UITextView()
        feedbackTextView.delegate = self
        feedbackTextView.font = UIFont.systemFont(ofSize: 16)
        feedbackTextView.layer.cornerRadius = 5
        view.addSubview(feedbackTextView)
        feedbackTextView.snp.makeConstraints { (make) in
            if Device.size() == Size.screen4Inch {
                make.top.equalTo(self.headerView.snp.bottom).offset(10)
                make.height.equalTo(130)
            }else {
                make.top.equalTo(self.headerView.snp.bottom).offset(50)
                make.height.equalTo(200)
            }
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        // 剩余字数
        numberL = UILabel()
        numberL.font = UIFont.systemFont(ofSize: 13)
        numberL.text = "200"
        numberL.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.addSubview(numberL)
        numberL.snp.makeConstraints { (make) in
            make.height.equalTo(15)
            make.width.equalTo(30)
            make.right.equalTo(self.feedbackTextView.snp.right).offset(-3)
            make.top.equalTo(self.feedbackTextView.snp.bottom).offset(-20)
        }
        
        // 增加按钮
        addBtn = BaseButton()
        addBtn.isEnabled = false
        addBtn.setBackgroundImage(#imageLiteral(resourceName: "Hook"), for: .normal)
        addBtn.addTarget(self, action: #selector(addAccount), for: .touchUpInside)
        view.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            if Device.size() == Size.screen4Inch {
                make.top.equalTo(self.feedbackTextView.snp.bottom).offset(10)
            }else {
                make.top.equalTo(self.feedbackTextView.snp.bottom).offset(20)
            }
            make.width.height.equalTo(Screen.width / 6)
            make.centerX.equalToSuperview()
        }
    
    }
    
    func addAccount() {
        print(123)
    }
}

extension FeedbackViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            addBtn.isEnabled = true
        }else {
            addBtn.isEnabled = false
        }
        guard (200 - Int((textView.text?.characters.count)!)) >= 0 else { return }
        self.numberL.text = String(describing: (200 - Int((textView.text?.characters.count)!)))
    }
    
}
