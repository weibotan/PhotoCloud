//
//  QiniuProvider.swift
//  PhotoCloud
//
//  Created by liupeng on 18/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Foundation

public class QiniuProvider {
    
    public static let instance = QiniuProvider()
    
    public func uploadFile(fileUrl:NSURL) {
        //init qnConfig
        guard let config = Preferences.SharedPreferences().currentQNAccountConfig else {
            // need set pref
            return
        }
        
        let qx =  Qiniu.init(QNURL: PhotoCloudStrings.QNURL, withQNBucketName: config.Bucket, withQNAccessKey: config.Access_Key, withQNSecretKey: config.Secret_Key)
        let token = qx.upToken()
        NSLog("token: %@", token)
        NSLog("fileUrl: %@", fileUrl)
        let upManager = QNUploadManager.init(configuration: QNConfiguration.build({ (build) in
            build.chunkSize =  4 * 1024 * 1024
        }))
        let uploadOption = QNUploadOption.init(mime: "", progressHandler: { (key, percent) in
            NSLog("uploading file: %@ percent: %@", key ?? "",percent)
            }, params: nil, checkCrc: true, cancellationSignal: nil)
        var fileName = fileUrl.lastPathComponent
        if let name = fileName where !Preferences.SharedPreferences().filePrefix.isEmpty  {
            fileName = Preferences.SharedPreferences().filePrefix + "_" + name
        }
        upManager.putFile(fileUrl.path, key: fileName, token: token, complete: { (info, key, resp) in
            if (resp == nil) {
                NSLog("upload fail %@", info.error.description)
                self.showNotify( "文件上传失败了伙计",desc: info.error.description)
                return
            }
            NSLog("upload success: %@", key ?? "")
            var fileName:String = ""
            if let userPutfileName = key {
                fileName = userPutfileName
            } else {
                fileName = resp.first!.1 as! String
            }
            let remoteUrl = "\(config.WebUrl!)/\(fileName)"
            NSLog("upload remote url: %@", remoteUrl)
            let pasteBoard = NSPasteboard.generalPasteboard()
            pasteBoard.declareTypes([NSStringPboardType], owner: nil)
            pasteBoard.setString(remoteUrl, forType: NSStringPboardType)
            self.showNotify( "文件上传成功\(fileName)",desc: remoteUrl)
            PhotoCloudStoreProvider.SharedPhotoCloudStore().addItem(PhotoCloudItemModel(fileName: fileName,downloadUrl: remoteUrl))
            }, option: uploadOption)
    }
    
    func showNotify(title:String, desc:String){
        if !Preferences.SharedPreferences().isNotifyEnable {
            return
        }
        NSApp.activateIgnoringOtherApps(true)
        let notification = NSUserNotification.init()
        notification.title = title
        notification.informativeText = desc
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
    }
    
    
    
}