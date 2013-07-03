//
//  VIClipboardListener.m
//  VIClipboardListener
//
//  Created by Vito on 13-5-17.
//  Copyright (c) 2013年 vito. All rights reserved.
//

#import "VIClipboardListener.h"

@interface VIClipboardListener() {
    NSUInteger pasteboardChangeCount;
}

@property (nonatomic) UIBackgroundTaskIdentifier bgTask;

@end

@implementation VIClipboardListener

static VIClipboardListener *sharedInstance;
+ (VIClipboardListener *)share {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (VIClipboardListener *)initWithDelegate:(id<VIClipboardListenerDelegate>)delegate {
    [VIClipboardListener share].delegate = delegate;
    return [VIClipboardListener share];
}

- (void)startListener {
    self.isListening = true;
    
    //Add observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pasteboardChanged:)
                                                 name:UIPasteboardChangedNotification
                                               object:nil];
    
    UIApplication* app = [UIApplication sharedApplication];
    self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self checkPasteBoardCount];
        
        //Stop task
        [app endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    });
}

- (void)checkPasteBoardCount {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSInteger changeCount = pasteboard.changeCount;
    
    while ([[UIApplication sharedApplication] backgroundTimeRemaining] >= 0 && self.isListening) {
        //NSLog(@"app in background, left %f second.",[[UIApplication sharedApplication] backgroundTimeRemaining]);
        if (changeCount != pasteboard.changeCount) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UIPasteboardChangedNotification object:nil];
            changeCount = pasteboard.changeCount;
            //NSLog(@"change count :%d" , changeCount);
        }
        [NSThread sleepForTimeInterval:1];
    }
}

- (void)stopListener {
    //Stop task
    self.isListening = false;
    if (self.bgTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }
    
    //Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pasteboardChanged:(NSNotification *)notification {
    [_delegate pasteboardChanged:[UIPasteboard generalPasteboard]];
}

@end
