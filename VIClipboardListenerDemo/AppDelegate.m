//
//  AppDelegate.m
//  VIClipboardListenerDemo
//
//  Created by Vito on 13-5-17.
//  Copyright (c) 2013年 vito. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[VIClipboardListener share] setDelegate:self];
    [[VIClipboardListener share] startListener];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"Got applicationWillEnterForeground");
    if ([VIClipboardListener share].isListening) {
        [[VIClipboardListener share] stopListener];
    }
}

- (void)pasteboardChanged:(UIPasteboard *)generatePasteboard {
    NSLog(@"Pasteboard chagne. String: %@\nStrings: %@\nURL: %@\nURLS: %@\nImage: %@\nImages: %@\nColor: %@\nColors: %@",
          generatePasteboard.string,
          generatePasteboard.strings,
          generatePasteboard.URL,
          generatePasteboard.URLs,
          generatePasteboard.image,
          generatePasteboard.images,
          generatePasteboard.color,
          generatePasteboard.colors);
}

@end
