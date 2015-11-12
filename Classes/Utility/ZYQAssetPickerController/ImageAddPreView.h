//
//  ImageAddPreView.h
//  TestAPP
//
//  Created by yangyong on 14-6-3.
//  Copyright (c) 2014年 gainline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageEditView.h"

@protocol  ImageAddPreViewDelegate;
@interface ImageAddPreView : UIView<ImageEditViewDelegate>

@property (nonatomic, strong) UILabel           *selectBeforeLab;
@property (nonatomic, strong) UILabel           *selectNumLab;
@property (nonatomic, strong) UILabel           *selectafterLab;

@property (nonatomic, strong) UIButton          *startPintuButton;
//@property (nonatomic, strong) NSArray           *imageArray;
@property (nonatomic, strong) UIScrollView      *contentView;
@property (nonatomic, weak)   id<ImageAddPreViewDelegate> delegateSelectImage;
@property (nonatomic, strong) NSMutableArray    *imageassets;
@property (nonatomic, strong) NSMutableArray    *imageEditViewArray;
- (void)addImageWith:(ALAsset *)asset;
- (void)deletePintuAction:(ALAsset *)asset;
- (void)reselectNumFrame;
- (void)reMoveAllResource;
@end


@protocol  ImageAddPreViewDelegate <NSObject>

- (void)startPintuAction:(ImageAddPreView *)sender;
- (void)deletePintuAction:(ImageAddPreView *)sender;

@end