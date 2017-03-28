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

class BaseViewController: UIViewController {

    let items = ["手动增加", "二维码扫描增加", "相册扫描二维码"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "back"))
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white];
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "bgNavi"), for: .default)
        self.navigationController?.navigationBar.shadowImage = #imageLiteral(resourceName: "line")
        
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
                self?.present(InputCodeViewController(), animated: true, completion: nil)
            case 1:
                self?.present(QRCodeViewController(), animated: true, completion: nil)
            default:
                let photoPickerVC = PhotoPickerViewController()
                photoPickerVC.sourceType = .photoLibrary
                photoPickerVC.delegate = self
                self?.present(photoPickerVC, animated: true, completion: nil)
            }
        }
        
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
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyLow])!
        let feature = detector.features(in: ciImage)
        if let results = feature.first as? CIQRCodeFeature {
            if let result = results.messageString {
                print(result)
                if result.characters.count >= 28 {
                    let patternDomain = "http://www.battleofballs.com"
                    let toIndex = result.index(result.startIndex, offsetBy: 28)
                    let subString = result.substring(to: toIndex)
                    
                    if patternDomain == subString {
                        
                        // 取出id
                        let patternId = "id=(\\d{6,10})"
                        let id = result.match(pattern: patternId, index: 1)
                        print("id=\(id.first!)")
                        
                        // 取出Account
                        let patternAccount = "Account=(.*)"
                        let account = result.match(pattern: patternAccount, index: 1)
                        let utfAccount = account.first!
                        print("account=\((utfAccount as NSString).removingPercentEncoding!)")
                        
                        if let utfAccount = (utfAccount as NSString).removingPercentEncoding {
                            // 存入plist
                            let dict = ["id":id.first!, "account":utfAccount]
                            PlistManager.standard.array.append(dict)
                            self.dismiss(animated: true, completion: nil)
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }else {
                        HUD.flash(.label("二维码不符"))
                    }
                }
            }
        }else {
            HUD.flash(.label("不是二维码"))
        }
        
        
    }
}
