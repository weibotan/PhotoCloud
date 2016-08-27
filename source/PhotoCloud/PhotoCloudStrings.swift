//
//  PhotoCloudStrings.swift
//  PhotoCloud
//
//  Created by liupeng on 18/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Foundation

struct PhotoCloudStrings {
     static let APPNAME = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String ?? "PhotoCloud"
     static let APP_VERSION = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
     static let COMMANDLINE_VERSION = "1.0.0"
     static let AcceptableImageFile = ["png","jpg","jpeg","gif"]
    
     static let QNURL = "http://www.7xptab.com1.z0.glb.clouddn.com/"
    
    //文件操作常量
    struct FileConstants {
        static func imageTempFilePath() -> String {
            var imageCacheTempFolder: String?
            if let cacheFolder = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first {
                imageCacheTempFolder = cacheFolder
            } else {
                imageCacheTempFolder = "~/temp"
            }
            imageCacheTempFolder  = imageCacheTempFolder! + "/PhotoCloudImageTemp"
            if !NSFileManager.defaultManager().fileExistsAtPath(imageCacheTempFolder!) {
                try! NSFileManager.defaultManager().createDirectoryAtPath(imageCacheTempFolder!, withIntermediateDirectories: true, attributes: nil)
            }
            return imageCacheTempFolder!
        }
        
        static func buildTempImagePath() -> String {
            let formatter: NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
            return buildTempImageCachePath(formatter.stringFromDate(NSDate()) + ".png")
        }
        
        static func buildTempImageCachePath(imageName: String) -> String {
            return imageTempFilePath() + "/" + imageName
        }
    }
}

