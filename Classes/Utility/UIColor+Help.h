//
//  UIColor+Help.h
//  Tuotuo
//
//  Created by yangyong on 14-4-28.
//  Copyright (c) 2014年 gainline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Help)

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;
+ (UIColor *) colorWithHexString: (NSString *) hexString;

@end
