//
//  ShortcutPreferencesViewController.swift
//  PhotoCloud
//
//  Created by liupeng on 18/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Cocoa

class ShortcutPreferencesViewController: NSViewController {
    @IBOutlet var shortcutview_upload: SRRecorderControl!
    @IBOutlet var shortcutview_snip: SRRecorderControl!
    var validator: SRValidator!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        shortcutview_upload.bind("value", toObject: NSUserDefaultsController.sharedUserDefaultsController(), withKeyPath: HotKeyMonitorUpload, options: nil )
        shortcutview_upload.delegate = self
        shortcutview_upload.allowsEscapeToCancelRecording = true
        shortcutview_upload.enabled = true
        
        shortcutview_snip.bind("value", toObject: NSUserDefaultsController.sharedUserDefaultsController(), withKeyPath: HotKeyMonitorCapture, options: nil )
        shortcutview_snip.delegate = self
        shortcutview_snip.allowsEscapeToCancelRecording = true
        shortcutview_snip.enabled = true
    }
    
}


// MARK: - MASPreferencesViewController
extension ShortcutPreferencesViewController: MASPreferencesViewController {
    
    override var identifier: String? {
        get {
            return "shortcut"
        }
        set {
            super.identifier = newValue
        }
    }
    
    var toolbarItemImage: NSImage! {
        return NSImage(named: "pref_shortcuts")
    }
    
    var toolbarItemLabel: String! {
        return "热键"
    }
}

// MARK: - SRRecorderControl
extension ShortcutPreferencesViewController: SRRecorderControlDelegate ,SRValidatorDelegate {

    func shortcutRecorderShouldBeginRecording(aRecorder: SRRecorderControl!) -> Bool {
        PTHotKeyCenter.sharedCenter().pause()
        return true
    }
    
    func shortcutRecorderDidEndRecording(aRecorder: SRRecorderControl!) {
        PTHotKeyCenter.sharedCenter().resume()
    }
    
    func shortcutValidatorShouldCheckMenu(aValidator: SRValidator!) -> Bool {
        return false
    }

}

