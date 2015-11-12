//  HomeMenuViewController
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ZYQAssetPickerController.h"
#import "MeituEditStyleViewController.h"

@interface HomeMenuViewController : UIViewController<UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate,ImageAddPreViewDelegate>

@property (nonatomic, strong) UIButton *meituMenuButton;
@property (nonatomic, strong) ZYQAssetPickerController *picker;

@end
