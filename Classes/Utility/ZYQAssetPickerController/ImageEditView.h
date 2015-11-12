//
//  ImageEditView.h
//  TestAPP
//
//  Created by yangyong on 14-6-4.
//  Copyright (c) 2014年 gainline. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ImageEditViewDelegate;
@interface ImageEditView : UIView

@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UIButton      *deleteButton;
@property (nonatomic, strong) ALAsset       *asset;
@property (nonatomic, assign) NSInteger     index;
@property (nonatomic, weak)   id<ImageEditViewDelegate> deleteEdit;

- (void)setImageAsset:(ALAsset *)asset index:(NSInteger)index;

@end

@protocol ImageEditViewDelegate <NSObject>

- (void)responseToDelete:(id)sender;

@end
