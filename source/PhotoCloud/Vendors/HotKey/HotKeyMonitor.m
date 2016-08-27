//
//  HotKeyMonitor.m
//  iCCTalk
//
//  Created by liupeng on 9/30/15.
//  Copyright © 2015 liupeng. All rights reserved.
//

#import "HotKeyMonitor.h"
#import <PTHotKey/PTHotKeyCenter.h>
#import <PTHotKey/PTHotKey+ShortcutRecorder.h>

static HotKeyMonitor* sInstance;
@implementation HotKeyMonitor
+ (instancetype) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[self alloc] init];
    });
    return sInstance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        // Shortcut recorder init
        NSUserDefaultsController *dc = [NSUserDefaultsController sharedUserDefaultsController];
        [dc addObserver:self forKeyPath:HotKeyMonitorUpload options:NSKeyValueObservingOptionInitial context:NULL];
        [dc addObserver:self forKeyPath:HotKeyMonitorCapture options:NSKeyValueObservingOptionInitial context:NULL];
        if (![[[NSUserDefaultsController sharedUserDefaultsController] defaults] valueForKey:@"hasBeenLaunched"]) {
            [self setupUserDefaults];
            [[[NSUserDefaultsController sharedUserDefaultsController] defaults] setValue:@YES forKey:@"hasBeenLaunched"];
        }
    }
    return self;
}

- (void) setupUserDefaults {
    // default HotKeyMonitorUpload key is command+u
    [[[NSUserDefaultsController sharedUserDefaultsController] defaults] setValue:@{@"charactersIgnoringModifiers" : @"u", @"characters" : @"u", @"keyCode" : @32, @"modifierFlags" : @1048576} forKey:HotKeyMonitorUpload];
    
    // default HotKeyMonitorCapture key is command+5
    [[[NSUserDefaultsController sharedUserDefaultsController] defaults] setValue:@{@"charactersIgnoringModifiers" : @"5", @"characters" : @"5", @"keyCode" : @23, @"modifierFlags" : @1048576} forKey:HotKeyMonitorCapture];
    
    
    [[[NSUserDefaultsController sharedUserDefaultsController] defaults] setValue:@YES forKey:@"notifications"];
    
}

- (void)dealloc
{
    [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self forKeyPath:HotKeyMonitorCapture];
    [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self forKeyPath:HotKeyMonitorUpload];
}


#pragma key-value observer
- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)anObject change:(NSDictionary *)aChange context:(void *)aContext
{
      NSLog(@"Key changed %@, %@",aKeyPath,anObject);
    if ([aKeyPath isEqualToString:HotKeyMonitorUpload])
    {
        //NSLog(@"Key changed");
        PTHotKeyCenter *hotKeyCenter = [PTHotKeyCenter sharedCenter];
        PTHotKey *oldHotKey = [hotKeyCenter hotKeyWithIdentifier:aKeyPath];
        [hotKeyCenter unregisterHotKey:oldHotKey];
        
        NSDictionary *newShortcut = [anObject valueForKeyPath:aKeyPath];
        
        if (newShortcut && (NSNull *)newShortcut != [NSNull null])
        {
            NSLog(@"HotKeyMonitorUpload newShortcut: %@",newShortcut);
            PTHotKey *newHotKey = [PTHotKey hotKeyWithIdentifier:aKeyPath
                                                        keyCombo:newShortcut
                                                          target:self
                                                          action:@selector(onHotKeyMonitorUpload)];
            [hotKeyCenter registerHotKey:newHotKey];
        }
    } else if ([aKeyPath isEqualToString:HotKeyMonitorCapture]){
        //NSLog(@"Key changed");
        PTHotKeyCenter *hotKeyCenter = [PTHotKeyCenter sharedCenter];
        PTHotKey *oldHotKey = [hotKeyCenter hotKeyWithIdentifier:aKeyPath];
        [hotKeyCenter unregisterHotKey:oldHotKey];
        
        NSDictionary *newShortcut = [anObject valueForKeyPath:aKeyPath];
        
        if (newShortcut && (NSNull *)newShortcut != [NSNull null])
        {
            NSLog(@"HotKeyMonitorCapture newShortcut: %@",newShortcut);
            PTHotKey *newHotKey = [PTHotKey hotKeyWithIdentifier:aKeyPath
                                                        keyCombo:newShortcut
                                                          target:self
                                                          action:@selector(onHotKeyMonitorCapture)];
            [hotKeyCenter registerHotKey:newHotKey];
        }
        
    } else
        [super observeValueForKeyPath:aKeyPath ofObject:anObject change:aChange context:aContext];
}

- (void)onHotKeyMonitorUpload
{
    if (self.hotKeyMonitorDelegate != nil) {
        [self.hotKeyMonitorDelegate onHotKeyMonitorUpload];
    }
}

- (void)onHotKeyMonitorCapture
{
    if (self.hotKeyMonitorDelegate != nil) {
       [self.hotKeyMonitorDelegate onHotKeyMonitorCapture];
    }
}

@end
