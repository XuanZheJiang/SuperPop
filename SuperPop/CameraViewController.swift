//
//  CameraViewController.swift
//  SuperPop
//
//  Created by JGCM on 17/2/28.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    var device: AVCaptureDevice!
    var input: AVCaptureInput!
    var output: AVCaptureMetadataOutput!
    var session: AVCaptureSession!
    var preview: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "back"))
        self.navigationItem.title = "扫描"
        
        // Input
        device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch {
            print("Input失败")
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
            print("session add input fail")
        }
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }else {
            print("session add output fail")
        }
        // 这行必须放在session初始化后，不然会crash
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
        
        // Preview
        preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill
        preview.frame.size = CGSize(width: 200, height: 200)
        preview.frame.origin = CGPoint(x: Screen.width / 2 - preview.frame.width / 2, y: 150)
        view.layer.insertSublayer(preview, at: 0)
        
        session.startRunning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension CameraViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects.count > 0 {
            if let meta = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                
                print(meta.stringValue)
                let result = meta.stringValue!
                
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
                            session.stopRunning()
                        }
                        
                        _ = navigationController?.popToRootViewController(animated: true)
                    }else {
                        print("二维码不符")
                    }
                }
 
            }else {
                print("扫描失败")
            }
            session.stopRunning()
        }
        
    }
    
}
