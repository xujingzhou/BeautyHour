//
//  TaskLoadingViewManager.m

//
//  Created by XiangqiTU on 4/22/13.
//  Copyright (c) 2013 Owen.Qin. All rights reserved.
//

#import "LoadingViewManager.h"

static LoadingViewManager   *loadingViewManager = nil;
static int Tag_LoadingView  = 9999;

@interface LoadingViewManager ()

- (void)removeHUDFromSuperView;

@end

@implementation LoadingViewManager

@synthesize HUD = _HUD;

#pragma mark - Singleton

+ (LoadingViewManager*)sharedInstance
{
    if (loadingViewManager == nil) {
        loadingViewManager = [[LoadingViewManager alloc] init];
    }
    return loadingViewManager;
}

+ (void)releaseInstance
{
    loadingViewManager = nil;
}

- (id) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Text HUD

- (void)showHUDWithText:(NSString*)hudText inView:(UIView *)containerView duration:(float)duration
{
    if (!self.HUD) {
        self.HUD = [[MBProgressHUD alloc] initWithView:containerView];
    }
    _HUD.mode  = MBProgressHUDModeText;
    _HUD.labelText = hudText;
    [containerView addSubview:_HUD];
    [_HUD show:YES];
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(hideHUDAfterDelay:) object: nil];
    [self hideHUDAfterDelay:duration];
}

//Loading View
- (void)showHUDWithText:(NSString *)hudText inView:(UIView *)containerView{
    if (!self.HUD) {
        self.HUD = [[MBProgressHUD alloc] initWithView:containerView];
    }
    _HUD.mode  = MBProgressHUDModeIndeterminate;
    _HUD.labelText = hudText;
    [containerView addSubview:_HUD];
    [_HUD show:YES];
}

- (void)showNetworkFailedText:(NSString *)hudText inView:(UIView *)containerView
{
    if (!self.HUD) {
        self.HUD = [[MBProgressHUD alloc] initWithView:containerView];
    }
    _HUD.mode  = MBProgressHUDModeCustomView;
    UIImageView *customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
//    [customImageView setImage:ImageNamed(@"activity_logo_error.png")];
    [customImageView setBackgroundColor:[UIColor clearColor]];
    _HUD.customView = customImageView;
    _HUD.labelText = hudText;
    [containerView addSubview:_HUD];
    [_HUD show:YES];
}

- (void)showText:(NSString *)hudText inView:(UIView *)containerView
{
    if (!self.HUD) {
        self.HUD = [[MBProgressHUD alloc] initWithView:containerView];
    }
    _HUD.mode  = MBProgressHUDModeText;
    _HUD.labelText = hudText;
    [containerView addSubview:_HUD];
    [_HUD show:YES];
}

- (void)hideHUDWithText:(NSString *)hudText afterDelay:(float)timeInterval{
    if (!self.HUD) {
        return;
    }
    _HUD.labelText = hudText;
    _HUD.mode = MBProgressHUDModeText;
    [self hideHUDAfterDelay:timeInterval];
}

- (void)hideHUDAfterDelay:(float)timeInterval{
    if (!self.HUD) {
        return;
    }
    
    [self performSelector:@selector(removeHUDFromSuperView) withObject:nil afterDelay:timeInterval];
}

- (void)removeHUDFromSuperView {
    [[NSNotificationCenter defaultCenter] postNotificationName:k_notification_name_removeHUD object:nil];
    
    [_HUD removeFromSuperview];
    _HUD = nil;
}

#pragma mark - HUD View With Tag

- (void)showLoadingViewInView:(UIView*)view withText:(NSString*)text
{
//    UIImageView *loadingView = (UIImageView *)[view viewWithTag:Tag_LoadingView];
//    if (loadingView == nil) {
//        loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
//        //[[MBProgressHUD alloc] initWithView:view];
//        
//        NSMutableArray *loadingViewArray = [NSMutableArray array];
//        for (int i = 0; i < 36; i++) {
//            NSString *imageName =  [NSString stringWithFormat:@"loading%.2d.png",i];
//            [loadingViewArray addObject:[UIImage imageNamed:imageName]];
//        }
//        loadingView.tag = Tag_LoadingView;
//        loadingView.center = view.center;
//        [view addSubview:loadingView];
//        [loadingView setAnimationImages:loadingViewArray];
//        [loadingView setAnimationDuration:1.8];
//        [loadingView setAnimationRepeatCount:NSIntegerMax];
//        [loadingView startAnimating];
////        [loadingView show:YES];
//    }
//    else {
////        loadingView.labelText = text;
//    }
//
// 
//    
    
    
    
    MBProgressHUD* loadingView = (MBProgressHUD*)[view viewWithTag:Tag_LoadingView];
    if (loadingView == nil) {
        loadingView = [[MBProgressHUD alloc] initWithView:view];
        loadingView.tag = Tag_LoadingView;
        loadingView.mode  = MBProgressHUDModeIndeterminate;
        loadingView.labelText = text;
        [view addSubview:loadingView];
        [loadingView show:YES];
    }
    else {
        loadingView.labelText = text;
    }
}

- (void)removeLoadingView:(UIView*)view
{
    MBProgressHUD* loadingView = (MBProgressHUD*)[view viewWithTag:Tag_LoadingView];
    if (loadingView) {
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
}

- (void)showLoadingViewInView:(UIView*)view withText:(NSString*)text viewTag:(int)viewTag
{
    MBProgressHUD* loadingView = (MBProgressHUD*)[view viewWithTag:viewTag];
    if (loadingView == nil) {
        loadingView = [[MBProgressHUD alloc] initWithView:view];
        loadingView.tag = viewTag;
        loadingView.mode  = MBProgressHUDModeIndeterminate;
        loadingView.labelText = text;
        [view addSubview:loadingView];
        [loadingView show:YES];
    }
    else {
        loadingView.labelText = text;
    }
}

- (void)removeLoadingView:(UIView*)view viewTag:(int)viewTag
{
    MBProgressHUD* loadingView = (MBProgressHUD*)[view viewWithTag:viewTag];
    if (loadingView) {
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
}

+ (void)showLoadViewWithText:(NSString *)text andShimmering:(BOOL)shimmering andBlurEffect:(BOOL)blur inView:(UIView *)view
{
    
    MBProgressHUD* loadingView = (MBProgressHUD*)[view viewWithTag:Tag_LoadingView];
    if (loadingView == nil) {
        loadingView = [[MBProgressHUD alloc] initWithView:view];
        loadingView.tag = Tag_LoadingView;
        loadingView.mode  = MBProgressHUDModeIndeterminate;
        loadingView.labelText = text;
        [view addSubview:loadingView];
        [loadingView show:YES];
    }
    else {
        loadingView.labelText = text;
    }
    
//    UIView *loadingView = [view viewWithTag:Tag_LoadingView];
//    if (loadingView) {
//        [loadingView removeFromSuperview];
//    }
//    else {
//        loadingView = [[UIView alloc] initWithFrame:view.bounds];
//        loadingView.tag = Tag_LoadingView;
//        
//        UIView *spriteView = [YXSpritesLoadingView showLoadViewWithText:text andShimmering:shimmering andBlurEffect:blur];
//        spriteView.center = loadingView.center;
//        [loadingView addSubview:spriteView];
//        [view addSubview:loadingView];
//    }
}

+ (void)showLoadViewInView:(UIView *)view
{
    if (!view)
        return;
    [LoadingViewManager showLoadViewWithText:@"加载中……" andShimmering:YES andBlurEffect:YES inView:view];
}

+ (void)hideLoadViewInView:(UIView *)view
{
    if (!view)
        return;
    
    MBProgressHUD* loadingView = (MBProgressHUD*)[view viewWithTag:Tag_LoadingView];
    if (loadingView) {
        [loadingView removeFromSuperview];
        loadingView = nil;
    } 
    
    
//    UIView *loadingView = [view viewWithTag:Tag_LoadingView];
//    if (loadingView) {
//        [loadingView removeFromSuperview];
//    }
}
@end
