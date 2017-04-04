//
//  CloudKitManager.swift
//  SuperPop
//
//  Created by JGCM on 2017/4/4.
//  Copyright © 2017年 JGCM. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    
    class func toFeedback(content: String, callBack: @escaping (_ error: Error?) -> Void) {
        let publicDataBase = CKContainer.default().publicCloudDatabase
        
        let store = CKRecord(recordType: "Feedback")
        store.setObject(Date() as CKRecordValue?, forKey: "date")
        store.setObject(content as CKRecordValue?, forKey: "content")
        store.setObject(DeviceInfoManager.default.toFormat() as CKRecordValue?, forKey: "device")
        
        publicDataBase.save(store) { (record, error) in
            callBack(error)
        }
    }
}
