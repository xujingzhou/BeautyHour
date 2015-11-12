//  AppDelegate
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeMenuViewController.h"

@implementation AppDelegate

- (void)initializePlat
{
    // Wechat
    [WXApi registerApp:kWechatAppID withDescription:D_LocalizedCardString(@"AppName")];
    
    // Sina Weibo
//    [WeiboSDK registerApp:kAppWeiboAppID];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Init share
    _scene = WXSceneTimeline;
    [self initializePlat];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    HomeMenuViewController *homeVC =  [[HomeMenuViewController alloc] init];
    UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:homeVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)showPreView
{
    if (_preview == nil)
    {
        _preview = [[ImageAddPreView alloc] initWithFrame:CGRectMake(0, self.window.frame.size.height - 135, self.window.frame.size.width, 135)];
        [_window addSubview:_preview];
    }
    
    [_preview setAlpha:0];
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_preview setAlpha:1];
                     } completion:^(BOOL finished) {
                         
                     }];
    [_preview setHidden:NO];
}


- (void)hiddenPreView
{
    [_preview setHidden:YES];
    [_preview setAlpha:0];
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_preview setAlpha:0];
                     } completion:^(BOOL finished) {

                     }];
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - WeiBo Delegate
//- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
//{
//    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
//    {
//        NSLog(@"didReceiveWeiboRequest");
//    }
//}
//
//- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
//{
//    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
//    {
//        NSString *strTitle = @"发送结果";
//        NSString *strMsg = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
//        
//        NSLog(@"%@ %@",strTitle, strMsg);
//    }
//    else if ([response isKindOfClass:WBAuthorizeResponse.class])
//    {
//        NSString *strTitle = @"认证结果";
//        NSString *strMsg = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
//        
//        NSLog(@"%@ %@",strTitle, strMsg);
//    }
//}

#pragma mark - Weixi Delegate
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        NSLog(@"%@ %@",strTitle, strMsg);
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        // 显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"Content by Wechat request"];
        NSString *strMsg = [NSString stringWithFormat:@"Title：%@ \nContent：%@ \nAttach Info：%@ \nThumbnail:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        NSLog(@"%@ %@",strTitle, strMsg);
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        // 从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"Launch from Weixi"];
        NSString *strMsg = @"Message from Weixi";
        
        NSLog(@"%@ %@",strTitle, strMsg);
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"Send result:"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        NSLog(@"%@ %@",strTitle, strMsg);
    }
}

#pragma mark - OpenURL
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL isSuc = NO;
    if ([url.scheme isEqualToString:kWechatAppID])
    {
        isSuc = [WXApi handleOpenURL:url delegate:self];
        NSLog(@"Wechat Url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    }
//    else
//    {
//        isSuc = [WeiboSDK handleOpenURL:url delegate:self];
//        NSLog(@"WeiboUrl %@ isSuc %d",url,isSuc == YES ? 1 : 0);
//    }
    
    return isSuc;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = NO;
    if ([url.scheme isEqualToString:kWechatAppID])
    {
        isSuc = [WXApi handleOpenURL:url delegate:self];
        NSLog(@"Wechat Url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    }
//    else
//    {
//        isSuc = [WeiboSDK handleOpenURL:url delegate:self];
//        NSLog(@"WeiboUrl %@ isSuc %d",url,isSuc == YES ? 1 : 0);
//    }
    
    return isSuc;
}

@end
