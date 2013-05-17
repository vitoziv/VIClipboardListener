//
//  VIClipboardListener.m
//  VIClipboardListener
//
//  Created by Vito on 13-5-17.
//  Copyright (c) 2013年 vito. All rights reserved.
//

#import "VIClipboardListener.h"

const NSInteger BACKGROUND_TIME = 600;//Ten minutes
const NSInteger SLEEP_TIME = 1;

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
    [self addObserver];
    
    UIApplication* app = [UIApplication sharedApplication];
    _bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:_bgTask];
        _bgTask = UIBackgroundTaskInvalid;
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self checkPasteBoardCount];
        
        //Stop task
        [app endBackgroundTask:_bgTask];
        _bgTask = UIBackgroundTaskInvalid;
    });
}

- (void)checkPasteBoardCount {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSInteger changeCount = pasteboard.changeCount;
    NSInteger bgTaskTime = BACKGROUND_TIME;
    while (bgTaskTime >= 0) {
        //NSLog(@"app in background, left %i second.",bgTaskTime);
        if (changeCount != pasteboard.changeCount) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UIPasteboardChangedNotification object:nil];
            changeCount = pasteboard.changeCount;
        }
        [NSThread sleepForTimeInterval:SLEEP_TIME];
        bgTaskTime -= SLEEP_TIME;
    }
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pasteboardChanged:)
                                                 name:UIPasteboardChangedNotification
                                               object:nil];
}

- (void)stopListener {
    //Stop task
    [[UIApplication sharedApplication] endBackgroundTask:_bgTask];
    _bgTask = UIBackgroundTaskInvalid;
    //Remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pasteboardChanged:(NSNotification *)notification {
    [_delegate pasteboardChanged:[UIPasteboard generalPasteboard]];
}

@end
