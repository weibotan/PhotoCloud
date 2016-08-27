//
//  HotKeyMonitor.h
//  iCCTalk
//
//  Created by liupeng on 9/30/15.
//  Copyright © 2015 liupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HotKeyMonitorUpload @"values.onHotKeyMonitorUpload"
#define HotKeyMonitorCapture @"values.onHotKeyMonitorCapture"
@protocol HotKeyMonitorDelegate

- (void)onHotKeyMonitorUpload;
- (void)onHotKeyMonitorCapture;

@end
@interface HotKeyMonitor : NSObject
@property (unsafe_unretained, nonatomic) id<HotKeyMonitorDelegate> hotKeyMonitorDelegate;
+ (instancetype) sharedInstance;
@end
