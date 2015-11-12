//  CLTextView
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//
#import "UIView+Frame.h"

typedef NS_ENUM(NSInteger, LabelStyle)
{
    kDefault = 0,
    kShadow,
    kInnerShadow,
    kGradientFill,
    kMultiPartGradient,
    kSynthesis,
};

static NSString* const CLTextViewActiveViewDidChangeNotification = @"CLTextViewActiveViewDidChangeNotificationString";
static NSString* const CLTextViewActiveViewDidTapNotification = @"CLTextViewActiveViewDidTapNotificationString";
static NSString* const CLTextViewActiveViewDidDoubleTapNotification = @"CLTextViewActiveViewDidDoubleTapNotificationString";

@interface CLTextView : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, assign) LabelStyle labelStyle;

+ (void)setActiveTextView:(CLTextView*)view;
- (void)setScale:(CGFloat)scale;
- (void)sizeToFitWithMaxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight;

@end

