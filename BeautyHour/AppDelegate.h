//  AppDelegate
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAddPreView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>
{
    enum WXScene _scene;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ImageAddPreView   *preview;

- (void)showPreView;
- (void)hiddenPreView;

@end