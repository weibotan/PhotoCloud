//
//  Extensions.swift
//  PhotoCloud
//
//  Created by liupeng on 18/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Foundation

// MARK: NSFileManager Extensions
public extension NSFileManager {
    func checkIfDirectoryExists(path: String) -> Bool {
        let fm = NSFileManager.defaultManager()
        var isDir: ObjCBool = false
        let fileExists = fm.fileExistsAtPath(path, isDirectory: &isDir)
        return fileExists && isDir
    }
    
    func checkIfFileExists(path: String) -> Bool {
        let fm = NSFileManager.defaultManager()
        var isDir: ObjCBool = false
        let fileExists = fm.fileExistsAtPath(path, isDirectory: &isDir)
        return fileExists && !isDir
    }
    
    func getApplicationDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)
        let supportDirectory = paths.first!
        return (supportDirectory as NSString).stringByAppendingPathComponent(PhotoCloudStrings.APPNAME)
    }
}

// MARK: String Extensions
public extension String {
    func fileName() -> String {
        return ((self as NSString).lastPathComponent as NSString).stringByDeletingPathExtension
    }
    
    func fileExtension() -> String {
        return (self as NSString).pathExtension
    }
    
    func appendPathComponent(suffix: String) -> String {
        return (self as NSString).stringByAppendingPathComponent(suffix)
    }
    
    func stringByAbbreviatingWithTildeInPath() -> String {
        return (self as NSString).stringByAbbreviatingWithTildeInPath
    }
}

// MARK: Date Extensions
public extension NSDate {
    func daysFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
}

// MARK: NSImage Extensions
extension NSImage {
    
    var imagePNGRepresentation: NSData? {
        if let data = TIFFRepresentation {
            if let rep = NSBitmapImageRep(data: data) {
                return rep.representationUsingType(.NSPNGFileType, properties: [:])
            }
        }
        return nil
    }
    
    func savePNG(path:String) -> Bool {
        if let data = imagePNGRepresentation {
            return data.writeToFile(path, atomically: true)
        }
        return false
    }
}

