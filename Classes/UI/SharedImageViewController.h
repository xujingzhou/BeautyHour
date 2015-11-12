//  SharedImageViewController
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ZYQAssetPickerController.h"
#import "HomeMenuViewController.h"

typedef NS_ENUM(NSUInteger, CLBlurType)
{
    kCLBlurTypeNormal = 0,
    kCLBlurTypeCircle,
    kCLBlurTypeBand,
    KCLSpotLight,
};

#define COMMON_ALERTVIEW_TAG 0
#define TWITTER_ALERTVIEW_TAG 1
#define FACEBOOK_ALERTVIEW_TAG 2

@interface SharedImageViewController : UIViewController

@property (nonatomic, strong) UIImageView   *sharedImageView;
@property (nonatomic, strong) UIScrollView  *contentView;
@property (nonatomic, strong) UIImage       *image;

@end
