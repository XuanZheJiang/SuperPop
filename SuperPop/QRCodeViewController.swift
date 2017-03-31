//
//  CameraViewController.swift
//  SuperPop
//
//  Created by JGCM on 17/2/28.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit
import AVFoundation
import PKHUD

class QRCodeViewController: AddViewController {

    var device: AVCaptureDevice!
    var input: AVCaptureInput!
    var output: AVCaptureMetadataOutput!
    var session: AVCaptureSession!
    var preview: AVCaptureVideoPreviewLayer!
    
    var topLeftView: UIImageView!
    var topRightView: UIImageView!
    var bottomLeftView: UIImageView!
    var bottomRightView: UIImageView!
    var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        prepareCamera()
    }
    
    func prepareUI() {
        
        self.headerView.image = #imageLiteral(resourceName: "headerQR")
        self.headerView.frame.size.width = 156
        
        containerView = UIView()
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(218)
        }
        
//        var imageItems = [#imageLiteral(resourceName: "topLeft"), #imageLiteral(resourceName: "topRight"), #imageLiteral(resourceName: "bottomLeft"), #imageLiteral(resourceName: "bottomRight")]
//        var viewItems = [topLeftView, topRightView, bottomLeftView, bottomRightView]
//        
//        for i in 0...3 {
//            viewItems[i] = UIImageView(image: imageItems[i])
//            containerView.addSubview(viewItems[i]!)
//        }
        
        
        
        topLeftView = UIImageView(image: #imageLiteral(resourceName: "topLeft"))
        topRightView = UIImageView(image: #imageLiteral(resourceName: "topRight"))
        bottomLeftView = UIImageView(image: #imageLiteral(resourceName: "bottomLeft"))
        bottomRightView = UIImageView(image: #imageLiteral(resourceName: "bottomRight"))
        
        containerView.addSubview(topLeftView)
        containerView.addSubview(topRightView)
        containerView.addSubview(bottomLeftView)
        containerView.addSubview(bottomRightView)
        
        topLeftView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
        topRightView.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
        }
        bottomLeftView.snp.makeConstraints { (make) in
            make.bottom.left.equalToSuperview()
        }
        bottomRightView.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
        }
        
    }
    
    func prepareCamera() {
        
        // Input
        device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch {
//            print("Input失败")
            return
        }
        
        // Output
        output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataOutputRectOfInterest(for: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        // Session
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPreset640x480
        if session.canAddInput(input) {
            session.addInput(input)
        }else {
//            print("session add input fail")
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }else {
//            print("session add output fail")
        }
        // 这行必须放在session初始化后，不然会crash
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
        
        // Preview
        preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill
        preview.frame.size = CGSize(width: 200, height: 200)
        preview.frame.origin = CGPoint(x: Screen.width / 2 - preview.frame.width / 2, y: Screen.height / 2 - preview.frame.height / 2)
        preview.cornerRadius = 5
        view.layer.addSublayer(preview)
        session.startRunning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        session.startRunning()
    }
    
}




// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects.count > 0 {
            if let meta = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                
//                print(meta.stringValue)
                let result = meta.stringValue!
                
                if result.characters.count >= 28 {
                    let patternDomain = "http://www.battleofballs.com"
                    let toIndex = result.index(result.startIndex, offsetBy: 28)
                    let subString = result.substring(to: toIndex)
                    
                    if patternDomain == subString {
                        
                        // 取出id
                        let patternId = "id=(\\d{6,10})"
                        let id = result.match(pattern: patternId, index: 1)
//                        print("id=\(id.first!)")
                        
                        // 取出Account
                        let patternAccount = "Account=(.*)"
                        let account = result.match(pattern: patternAccount, index: 1)
                        let utfAccount = account.first!
//                        print("account=\((utfAccount as NSString).removingPercentEncoding!)")
                        
                        if let utfAccount = (utfAccount as NSString).removingPercentEncoding {
                            // 存入plist
                            let dict = ["id":id.first!, "account":utfAccount]
                            PlistManager.standard.array.append(dict)
                            session.stopRunning()
                        }
                        session.stopRunning()
                        self.dismiss(animated: true, completion: nil)
                    }else {
                        HUD.flash(.label("二维码不符"), delay: 0.5)
                        session.stopRunning()
                    }
                }
 
            }else {
                HUD.flash(.label("扫描失败"), delay: 0.5)
                session.stopRunning()
            }
        }
        
    }
    
}
