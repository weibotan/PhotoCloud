//
//  Preferences.swift
//  PhotoCloud
//
//  Created by liupeng on 18/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Foundation

private let _SharedPreferences = Preferences();

class Preferences {
    class func SharedPreferences() -> Preferences {
        return _SharedPreferences
    }
    
    private var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    private struct Keys {
        static let Pref_QN_Account_Bucket = "Pref_QN_Account_Bucket"
        static let Pref_QN_Account_Access_Key = "Pref_QN_Account_Access_Key"
        static let Pref_QN_Account_Secret_Key = "Pref_QN_Account_Secret_Key"
        static let Pref_QN_Account_Web_Url = "Pref_QN_Account_Web_Url"
        
        static let Pref_Gerenal_AtLogin = "Pref_Gerenal_AtLogin"
        static let Pref_Gerenal_Notify = "Pref_Gerenal_Notify"
        static let Pref_Gerenal_File_prefix = "Pref_Gerenal_File_prefix"
    }
    
    private struct DefaultValues {
        
    }
    
    var currentQNAccountConfig:QNAccountConfig? {
        set{
            userDefaults.setObject(newValue?.Bucket, forKey:Keys.Pref_QN_Account_Bucket)
            userDefaults.setObject(newValue?.Access_Key, forKey:Keys.Pref_QN_Account_Access_Key)
            userDefaults.setObject(newValue?.Secret_Key, forKey:Keys.Pref_QN_Account_Secret_Key)
            userDefaults.setObject(newValue?.WebUrl, forKey:Keys.Pref_QN_Account_Web_Url)
        }
        
        get {
            if let bucket = userDefaults.objectForKey(Keys.Pref_QN_Account_Bucket) as? String {
                return QNAccountConfig(bucket: bucket,ak: userDefaults.objectForKey(Keys.Pref_QN_Account_Access_Key) as? String,sk: userDefaults.objectForKey(Keys.Pref_QN_Account_Secret_Key) as? String, webUrl: userDefaults.objectForKey(Keys.Pref_QN_Account_Web_Url) as? String)
            }
            
            return nil
        }
    }
    
    var isAtLogin:Bool {
        set {
          userDefaults.setObject(newValue, forKey:Keys.Pref_Gerenal_AtLogin)
        }
        get {
            if let atlogin_state = userDefaults.objectForKey(Keys.Pref_Gerenal_AtLogin) as? Bool {
                return atlogin_state
            }
            
            return false
        }
    }
    
    var isNotifyEnable:Bool {
        set {
            userDefaults.setObject(newValue, forKey:Keys.Pref_Gerenal_Notify)
        }
        get {
            if let notify_state = userDefaults.objectForKey(Keys.Pref_Gerenal_Notify) as? Bool {
                return notify_state
            }
            
            return false
        }
    }
    
    var filePrefix:String {
        set {
            userDefaults.setObject(newValue, forKey:Keys.Pref_Gerenal_File_prefix)
        }
        get {
            if let prefix = userDefaults.objectForKey(Keys.Pref_Gerenal_File_prefix) as? String {
                return prefix
            }
            
            return ""
        }
    }
        
    
}

public struct QNAccountConfig {
    var Bucket: String?
    var Access_Key: String?
    var Secret_Key: String?
    var WebUrl: String?

    init(bucket:String?, ak:String?, sk: String?, webUrl: String? ){
        Bucket = bucket
        Access_Key = ak
        Secret_Key = sk
        WebUrl = webUrl
    }
}
