//
//  PhotoCloudItemModel.swift
//  PhotoCloud
//
//  Created by liupeng on 19/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Foundation
import RealmSwift

class PhotoCloudItemModel: Object {
    dynamic var fileName = ""
    dynamic var downloadUrl = ""
    dynamic var createTime = ""
    
    convenience required init(fileName: String,downloadUrl: String) {
        self.init()
        self.fileName = fileName
        self.downloadUrl = downloadUrl
        self.createTime = String(Int64(NSDate().timeIntervalSince1970*1000))
    }
    
    override static func primaryKey() -> String? {
        return "createTime"
    }
}