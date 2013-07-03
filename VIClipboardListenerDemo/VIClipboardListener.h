//
//  VIClipboardListener.h
//  VIClipboardListener
//
//  Created by Vito on 13-5-17.
//  Copyright (c) 2013年 vito. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VIClipboardListenerDelegate <NSObject>

- (void)pasteboardChanged:(UIPasteboard *)generatePasteboard;

@end

@interface VIClipboardListener : NSObject

@property (nonatomic, strong) id<VIClipboardListenerDelegate> delegate;

+ (VIClipboardListener *)share;
+ (VIClipboardListener *)initWithDelegate:(id<VIClipboardListenerDelegate>)delegate;

- (void)startListener;
- (void)stopListener;

@property Boolean isListening;

@end
