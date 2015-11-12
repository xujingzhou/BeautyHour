//  CLBlurBand
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//
#import "CLBlurBand.h"

@implementation CLBlurBand

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        _scale    = 1;
        _rotation = 0;
        _offset   = 0;
    }
    return self;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    [self calcTransform];
}

- (void)setRotation:(CGFloat)rotation
{
    _rotation = rotation;
    [self calcTransform];
}

- (void)setOffset:(CGFloat)offset
{
    _offset = offset;
    [self calcTransform];
}

- (void)calcTransform
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, -self.offset*sin(self.rotation), self.offset*cos(self.rotation));
    transform = CGAffineTransformRotate(transform, self.rotation);
    transform = CGAffineTransformScale(transform, 1, self.scale);
    self.transform = transform;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setCenter:(CGPoint)center
{
    [super setCenter:center];
    [self setNeedsDisplay];
}

- (void)setTransform:(CGAffineTransform)transform
{
    [super setTransform:transform];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rct = self.bounds;
    rct.origin.y = 0.3*rct.size.height;
    rct.size.height *= 0.4;
    
    CGContextSetLineWidth(context, 1/self.scale);
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    CGContextSetLineWidth(context, 5);
    CGContextStrokeRect(context, rct);
    
    self.alpha = 1;
    [UIView animateWithDuration:kCLEffectToolAnimationDuration
                          delay:1
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}

@end

