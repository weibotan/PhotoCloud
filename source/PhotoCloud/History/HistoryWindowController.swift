//
//  HistoryWindowController.swift
//  PhotoCloud
//
//  Created by liupeng on 19/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Cocoa
import RealmSwift
class HistoryWindowController: NSWindowController {
    @IBOutlet var tableview: NSTableView!

    @IBOutlet var scrollview: NSScrollView!
    private var uploadHistory = NSMutableArray()
      @IBOutlet var view: NSView!
    convenience init() {
        self.init(windowNibName: "HistoryWindowController")
    }
    override func windowDidLoad() {
        super.windowDidLoad()
       
        
        tableview.selectionHighlightStyle = .Regular
        tableview.gridStyleMask = .GridNone
        tableview.registerNib(NSNib(nibNamed: "HistoryTableCell", bundle: nil), forIdentifier: "HistoryTableCell")
        
       
        
        NSNotificationCenter.defaultCenter().addObserverForName(NSWindowWillCloseNotification, object: self.window, queue: nil) { notification in
            NSApp.stopModal()
        }
        
        if let window = window {
            window.title = "上传记录"
            window.styleMask = NSTitledWindowMask | NSClosableWindowMask | NSFullSizeContentViewWindowMask | NSResizableWindowMask
        }

    }
    
    override func showWindow(sender: AnyObject?) {
        super.showWindow(sender)
        uploadHistory.removeAllObjects()
        let allHistorys = PhotoCloudStoreProvider.SharedPhotoCloudStore().photoCloudItemList
        for item in allHistorys {
            uploadHistory.addObject(item)
        }
        tableview.reloadData()
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension HistoryWindowController: NSTableViewDataSource {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.uploadHistory.count
    }
    
}

extension HistoryWindowController: NSTableViewDelegate {
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier("HistoryTableCell", owner: tableView) as? HistoryTableCell
        let item = self.uploadHistory[row] as? PhotoCloudItemModel
        cell?.tx_fileName.stringValue = item?.fileName ?? ""
        cell?.tx_downloadUrl.stringValue = item?.downloadUrl ?? ""
        cell?.imageview?.setImageURL(item?.downloadUrl ?? "")
        cell?.wantsLayer = true
        cell?.layer?.backgroundColor = NSColor.whiteColor().CGColor
        return cell
    }
}
