//  MeituEditStyleViewController
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MeituImageEditView.h"
#import "GLStoryboardSelectView.h"
#import "SharedImageViewController.h"

typedef NS_ENUM(NSUInteger, ScrollViewStatus)
{
    kPuzzleScrollView = 0,
    kBorderScrollView,
    kStickerScrollView,
    kFaceScrollView,
    kFilterScrollView,
};

@interface MeituEditStyleViewController : UIViewController<GLStoryboardSelectViewDelegate>

@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) NSArray *effectImages;

@property (nonatomic, strong) NSMutableArray    *assetsImage;
@property (nonatomic, strong) NSArray           *assets;
@property (nonatomic, strong) UIScrollView      *contentView;
@property (nonatomic, assign) BOOL              *isCallBack;


@property (nonatomic, strong) UIImageView       *bringPosterView;
@property (nonatomic, strong) UIImageView       *freeBgView;

// 添加／删除按钮
@property (nonatomic, strong) UIView              *boardAndEditView;

@property (nonatomic, strong) UIButton            *editbutton;


@property (nonatomic, strong) UIView            *bottomView;
//

@property (nonatomic, strong) UIButton          *puzzleButton;
@property (nonatomic, strong) UIButton          *borderButton;
@property (nonatomic, strong) UIButton          *stickerButton;
@property (nonatomic, strong) UIButton          *faceButton;
@property (nonatomic, strong) UIButton          *filterButton;

@property (nonatomic, strong) UIButton          *selectControlButton;


@property (nonatomic, strong) GLStoryboardSelectView      *storyboardView;

@property (nonatomic, strong) UIScrollView                *bottomControlView;

@property (nonatomic, strong) GLStoryboardSelectView      *borderView;

@property (nonatomic, strong) GLStoryboardSelectView      *stickerView;

@property (nonatomic, strong) GLStoryboardSelectView      *faceView;

@property (nonatomic, strong) GLStoryboardSelectView      *filterView;


@property (nonatomic, strong) UIButton          *selectedStoryboardBtn;

@property (nonatomic, strong) UIButton          *selectedPosterBtn;

@property (nonatomic, strong) UIColor           *selectedBoardColor;

@property (nonatomic, assign) NSInteger         selectStoryBoardStyleIndex;
@property (nonatomic, assign) BOOL              isFirst;

@end
