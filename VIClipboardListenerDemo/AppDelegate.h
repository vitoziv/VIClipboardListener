//
//  AppDelegate.h
//  VIClipboardListenerDemo
//
//  Created by Vito on 13-5-17.
//  Copyright (c) 2013年 vito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIClipboardListener.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,VIClipboardListenerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
