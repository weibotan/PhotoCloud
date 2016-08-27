//
//  UITools.swift
//  PhotoCloud
//
//  Created by liupeng on 22/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Foundation

struct UITools {
    static func disableTextFieldDefaultFocus(sender: NSTextField){
        sender.refusesFirstResponder = true
    }
    
    static func removeTextFieldFocus(sender: NSTextField){
        sender.window?.makeFirstResponder(nil)
    }

}