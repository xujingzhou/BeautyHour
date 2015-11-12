//
//  UIButton+help.m
//  Tuotuo
//
//  Created by Apple on 14-1-14.
//  Copyright (c) 2014年 Gaialine. All rights reserved.
//

#import "UIButton+Help.h"
#import "UIImage+Help.h"

@implementation UIButton (Help)

- (void)setBackgroundColorNormal:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor
{
    [self setBackgroundImage:[UIImage imageWithColor:normalColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    
//    [self setBackgroundImage:[UIImage imageNamed:@"btn_meitu_edit_highlight"] forState:UIControlStateNormal];
//    [self setBackgroundImage:[UIImage imageNamed:@"btn_meitu_edit_normal"] forState:UIControlStateHighlighted];
}


- (void)        buttonWithNormalImageName:(NSString *)normalImageName
                     highlightedImageName:(NSString *)highlightedImageName
                               edgeInsets:(UIEdgeInsets)edgeInsets
                           layerImageName:(NSString *)layerImageName
                                titleName:(NSString *)titleName
                                titleFont:(float)titleFont
                                   target:(id)target
                                   action:(SEL)sel
{
    if(UIEdgeInsetsEqualToEdgeInsets(edgeInsets, UIEdgeInsetsZero))
    {
        edgeInsets = UIEdgeInsetsMake(15, 15, 15, 10);
    }
    
    if (normalImageName) {
        UIImage* image = [UIImage stretchableImage:[UIImage imageNoCache:normalImageName] edgeInsets:edgeInsets];
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    if (highlightedImageName) {
        UIImage* highlightedImage = [UIImage stretchableImage:[UIImage imageNoCache:highlightedImageName] edgeInsets:edgeInsets];
        [self setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    }
    
    if (layerImageName) {
        UIImage* layerImage = [UIImage imageNoCache:layerImageName];
        UIImageView *layerImageView = [[UIImageView alloc]initWithImage:layerImage];
        layerImageView.center = self.center;
        [self addSubview:layerImageView];
    }
    
    if (titleName) {
        [self setTitle:titleName forState:UIControlStateNormal];
        [self setTitle:titleName forState:UIControlStateHighlighted];
    }
    
    if (titleFont == 0) {
        titleFont = 12.0f;
    }
	
	self.titleLabel.font = [UIFont systemFontOfSize:titleFont];
    self.titleLabel.textColor = [UIColor whiteColor];
    
    self.titleLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    self.titleLabel.shadowOffset = CGSizeMake(1.0f, -1.0f);
    
    [self addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)        buttonWithSelectedImageName:(NSString*)selectedImageName
                          disabledImageName:(NSString*)disabledImageName
                                 edgeInsets:(UIEdgeInsets)edgeInsets
{
    if (selectedImageName) {
        UIImage* image = [UIImage stretchableImage:[UIImage imageNoCache:selectedImageName] edgeInsets:edgeInsets];
        [self setBackgroundImage:image forState:UIControlStateSelected];
    }
    
    if (disabledImageName) {
        UIImage* highlightedImage = [UIImage stretchableImage:[UIImage imageNoCache:disabledImageName] edgeInsets:edgeInsets];
        [self setBackgroundImage:highlightedImage forState:UIControlStateDisabled];
    }
}

- (void)        buttonWithNormalTitleColor:(UIColor *)normalColor
                     highlightedTitleColor:(UIColor *)highlightedColor
{
    normalColor = normalColor ? normalColor : [UIColor whiteColor];
    highlightedColor = highlightedColor ? highlightedColor : [UIColor whiteColor];
    
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    [self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
}

+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)backgroundColor
                       target:(id)target
                       action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        [button setTitleColor:titleColor forState:UIControlStateHighlighted];
    }
    
    if (backgroundColor) {
        [button setBackgroundColor:backgroundColor];
    }
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
