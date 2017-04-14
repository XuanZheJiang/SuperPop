//
//  BaseViewController.swift
//  SuperPop
//
//  Created by JGCM on 2017/3/28.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
import PKHUD
import MessageUI
import Alamofire
import SwiftyJSON

class BaseViewController: UIViewController {

    let items = ["手动添加", "二维码", "相册", "意见反馈", "评价"]
    var noCountImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(self.shareAction))
        
        noCountImageView = UIImageView(image: #imageLiteral(resourceName: "NoCountT"))
        noCountImageView.frame.size = CGSize(width: 148, height: 29)
        noCountImageView.center.x = view.center.x
        noCountImageView.frame.origin.y = 100
        view.addSubview(noCountImageView)
        
        self.view.layer.contents = #imageLiteral(resourceName: "back").cgImage
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white];
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "bgNavi"), for: .default)
        self.navigationController?.navigationBar.shadowImage = #imageLiteral(resourceName: "line")
        
        let menu = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "添加", items: items as [AnyObject] )

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
                self?.present(InputCodeViewController(), animated: true, completion: nil)
            case 1:
                self?.present(QRCodeViewController(), animated: true, completion: nil)
            case 2:
                let photoPickerVC = PhotoPickerViewController()
                photoPickerVC.sourceType = .photoLibrary
                photoPickerVC.navigationBar.barTintColor = Color.naviColor
                photoPickerVC.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                photoPickerVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
                photoPickerVC.delegate = self
                self?.present(photoPickerVC, animated: true, completion: nil)
            case 3:
                self?.present(FeedbackViewController(), animated: true, completion: nil)
            case 4:
                UpdateManager.evaluation()
            default:
                break
            }
        }
        
    }

    // 分享
    func shareAction() {
        let shareURL = URL(string: "https://itunes.apple.com/us/app/slpop/id1221806149?l=zh&ls=1&mt=8")!
        let shareString = "https://itunes.apple.com/us/app/slpop/id1221806149?l=zh&ls=1&mt=8"
        let shareTitle = "SLPop"
        let shareImage = #imageLiteral(resourceName: "shareIcon")
        let items = [shareString, shareURL, shareTitle, shareImage] as [Any]
        let shareVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(shareVC, animated: true, completion: nil)
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension BaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // 取出选中图片
        let pickerImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData = UIImagePNGRepresentation(pickerImage)!
        let ciImage = CIImage(data: imageData)!
        
        // 创建探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
        let feature = detector.features(in: ciImage)
        if let results = feature.first as? CIQRCodeFeature {
            if let result = results.messageString {
//                print(result)
                if result.characters.count >= 28 {
                    
                    Alamofire.request(URL(string: POST.changeShort)!, method: .post, parameters: ["url":result, "access_type":"web"], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            
                            let patternDomain = "http://www.battleofballs.com"
                            let toIndex = result.index(result.startIndex, offsetBy: 28)
                            let subString = result.substring(to: toIndex)
                            
                            if patternDomain == subString {
                                
                                // 取出id
                                let patternId = "id=(\\d{6,10})"
                                let id = result.match(pattern: patternId, index: 1)
                                
                                // 取出Account
                                let patternAccount = "Account=(.*)"
                                let account = result.match(pattern: patternAccount, index: 1)
                                let utfAccount = account.first!
                                
                                if let utfAccount = (utfAccount as NSString).removingPercentEncoding {
                                    // 存入plist
                                    let dict = ["id":id.first!, "account":utfAccount, "url":json["tinyurl"].stringValue]
                                    PlistManager.standard.array.append(dict)
                                    self.dismiss(animated: true, completion: nil)
                                    self.dismiss(animated: true, completion: nil)
                                }
                                
                            }else {
                                HUD.flash(.label("二维码不符"), delay: 0.5)
                            }
                            
                        case .failure( _):
                            HUD.flash(.label("网络超时\n二维码解析失败"), delay: 1.0)
                        }
                        
                    }
                    
                }
            }
        }else {
            HUD.flash(.label("没有找到二维码"), delay: 1.0)
        }
        
        
    }
}

extension BaseViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
    }
    
    
}
