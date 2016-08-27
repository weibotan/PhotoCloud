//
//  FinderSelectionProvider.swift
//  PhotoCloud
//
//  Created by liupeng on 18/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Foundation
import ScriptingBridge

public class FinderSelectionProvider {
    
    public static let instance = FinderSelectionProvider()
    
    private init(){}
    
    public func getSelectedFolders() -> [NSURL] {
        guard let finder = SBApplication(bundleIdentifier: "com.apple.finder") as? FinderApplication,
            let result = finder.selection else {
                NSLog("No items selected")
                return []
        }
        guard let selection = result.get() else {
            NSLog("No items selected")
            return []
        }
        
        let items = selection.arrayByApplyingSelector(Selector("URL"))
        let fm = NSFileManager.defaultManager()
        return items.filter {
            item -> Bool in
            let url = NSURL(string: item as! String)!
            return fm.checkIfDirectoryExists(url.path!)
            }.map { return NSURL(string: $0 as! String)!}
    }
    
    public func getSelectedFiles() -> [NSURL] {
        guard let finder = SBApplication(bundleIdentifier: "com.apple.finder") as? FinderApplication,
            let result = finder.selection else {
                NSLog("No items selected")
                return []
        }
        guard let selection = result.get() else {
            NSLog("No items selected")
            return []
        }
        
        let items = selection.arrayByApplyingSelector(Selector("URL"))
        let fm = NSFileManager.defaultManager()
        return items.filter {
            item -> Bool in
            let url = NSURL(string: item as! String)!
            return fm.checkIfFileExists(url.path!)
            }.map { return NSURL(string: $0 as! String)!}
    }
    
    
    public func getSelectedImages()->[NSURL] {
       let urls = getSelectedFiles()
        return urls.filter({ (item) -> Bool in
            guard let fileExtension = item.path?.fileExtension() else {
                return false
            }
            return PhotoCloudStrings.AcceptableImageFile.contains(fileExtension.lowercaseString)
        })
    }
    

}