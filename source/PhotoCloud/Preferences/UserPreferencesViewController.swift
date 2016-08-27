//
//  UserPreferencesViewController.swift
//  PhotoCloud
//
//  Created by liupeng on 18/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Cocoa

class UserPreferencesViewController: NSViewController {
    @IBOutlet var tx_ak: NSTextField!
    @IBOutlet var tx_sk: NSTextField!
    @IBOutlet var tx_bucket: NSTextField!
    @IBOutlet var tx_weburl: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.loadLastQNConfig()
        UITools.disableTextFieldDefaultFocus(self.tx_ak)
        UITools.disableTextFieldDefaultFocus(self.tx_sk)
        UITools.disableTextFieldDefaultFocus(self.tx_bucket)
        UITools.disableTextFieldDefaultFocus(self.tx_weburl)
    }
    
    func loadLastQNConfig() {
        guard let config = Preferences.SharedPreferences().currentQNAccountConfig else {
            return
        }
        tx_bucket.stringValue = config.Bucket!
        tx_ak.stringValue = config.Access_Key!
        tx_sk.stringValue = config.Secret_Key!
        tx_weburl.stringValue = config.WebUrl!
    }
    
    @IBAction func savePref(sender: AnyObject) {
        if isEmptyTextField(tx_bucket) || isEmptyTextField(tx_ak) || isEmptyTextField(tx_sk) || isEmptyTextField(tx_weburl){
            return
        }
        Preferences.SharedPreferences().currentQNAccountConfig = QNAccountConfig(bucket: tx_bucket.stringValue,ak: tx_ak.stringValue,sk: tx_sk.stringValue, webUrl: tx_weburl.stringValue)
        
        self.view.window?.close()
    }
    
    func isEmptyTextField(sender: NSTextField) -> Bool {
        return sender.stringValue.isEmpty
    }
    
   }

// MARK: - MASPreferencesViewController
extension UserPreferencesViewController: MASPreferencesViewController {
    
    override var identifier: String? {
        get {
            return "user"
        }
        set {
            super.identifier = newValue
        }
    }
    
    var toolbarItemImage: NSImage! {
        return NSImage(named: NSImageNameUserAccounts)
    }
    
    var toolbarItemLabel: String! {
        return "账户"
    }
}
