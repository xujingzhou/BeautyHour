//  CLTextView
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//

#import "CLTextView.h"
#import "CircleView.h"
#import "FXLabel.h"

#define FontSize 50

@implementation CLTextView
{
    FXLabel *_label;
    UIButton *_deleteButton;
    CircleView *_circleView;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}

+ (void)setActiveTextView:(CLTextView*)view
{
    static CLTextView *activeView = nil;
    if(view != activeView)
    {
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
        
        NSNotification *notif = [NSNotification notificationWithName:CLTextViewActiveViewDidChangeNotification object:view userInfo:nil];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notif waitUntilDone:YES];
        
        NSLog(@"Text view is actived.");
    }
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 132, 132)];
    
    if(self)
    {
        self.text = @"";
        
        _label = [[FXLabel alloc] init];
        _label.numberOfLines = 0;
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:FontSize];
        _label.minimumScaleFactor = 1/FontSize;
        _label.adjustsFontSizeToFitWidth = YES;
        _label.textAlignment = NSTextAlignmentCenter;
        
        _label.shadowColor = nil;
        _label.shadowOffset = kShadowOffset;
        _label.shadowBlur = kShadowBlur;
        _label.innerShadowColor = nil;
        _label.innerShadowOffset = kInnerShadowOffset;
        _label.innerShadowBlur = kInnerShadowBlur;
        _label.textColor = kGradientStartColor;
        [self addSubview:_label];
        
        CGSize size = [_label sizeThatFits:CGSizeMake(FLT_MAX, FLT_MAX)];
        _label.frame = CGRectMake(16, 16, size.width, size.height);
        self.frame = CGRectMake(0, 0, size.width + 32, size.height + 32);
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"makecards_picture_turnoff_icon"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
        _deleteButton.center = _label.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _circleView.center = CGPointMake(_label.width + _label.left, _label.height + _label.top);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _circleView.radius = 0.7;
        _circleView.color = [UIColor whiteColor];
        _circleView.borderColor = [UIColor redColor];
        _circleView.borderWidth = 5;
        [self addSubview:_circleView];
        
        _arg = 0;
        [self setScale:1];
        
        [self initGestures];
    }
    return self;
}

- (void)initGestures
{
    _label.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];
//    singleRecognizer.delegate = self;
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [_label addGestureRecognizer:singleRecognizer];
    
    UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidDubleTap:)];
//    doubleRecognizer.delegate=self;
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [_label addGestureRecognizer:doubleRecognizer];
    
    // 如果双击确定偵測失败才會触发单击
    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
    
    [_label addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view = [super hitTest:point withEvent:event];
    
    if(view == self)
    {
        return nil;
    }
    return view;
}

#pragma mark- Properties

- (void)setAvtive:(BOOL)active
{
    if (isStringEmpty(_text))
    {
        _deleteButton.hidden = YES;
        _circleView.hidden = YES;
        _label.layer.borderWidth = 0;
    }
    else
    {
        _deleteButton.hidden = !active;
        _circleView.hidden = !active;
        _label.layer.borderColor = [UIColor redColor].CGColor;
        _label.layer.borderWidth = (active) ? 1/_scale : 0;
    }
}

- (BOOL)active
{
    return !_deleteButton.hidden;
}

- (void)sizeToFitWithMaxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight
{
    self.transform = CGAffineTransformIdentity;
    _label.transform = CGAffineTransformIdentity;
    
    CGSize size = [_label sizeThatFits:CGSizeMake(width / (15/FontSize), FLT_MAX)];
    _label.frame = CGRectMake(16, 16, size.width, size.height);
    
    CGFloat viewW = (_label.width + 32);
    CGFloat viewH = _label.font.lineHeight;
    
    CGFloat ratio = MIN(width / viewW, lineHeight / viewH);
    [self setScale:ratio];
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    self.transform = CGAffineTransformIdentity;
    _label.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_label.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_label.height + 32)) / 2;
    rct.size.width  = _label.width + 32;
    rct.size.height = _label.height + 32;
    self.frame = rct;
    
    _label.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    self.transform = CGAffineTransformMakeRotation(_arg);
    _label.layer.borderWidth = 1/_scale;
    _label.layer.cornerRadius = 3/_scale;
}

- (void)setFillColor:(UIColor *)fillColor
{
    _label.textColor = fillColor;
    _label.gradientStartColor = fillColor;
    
    NSLog(@"setFillColor invoked.");
}

- (UIColor*)fillColor
{
    return _label.textColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _label.shadowColor = borderColor;
}

- (UIColor*)borderColor
{
    return _label.shadowColor;
}

//- (void)setBorderWidth:(CGFloat)borderWidth
//{
//    _label.strokeSize = borderWidth;
//}
//
//- (CGFloat)borderWidth
//{
//    return _label.strokeSize;
//}

- (void)setFont:(UIFont *)font
{
    _label.font = [font fontWithSize:FontSize];
    NSLog(@"setFont invoked.");
}

- (UIFont*)font
{
    return _label.font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _label.textAlignment = textAlignment;
}

- (NSTextAlignment)textAlignment
{
    return _label.textAlignment;
}

- (void)setText:(NSString *)text
{
    NSLog(@"setText invoked.");
    
    if(![text isEqualToString:_text])
    {
        _text = text;
        NSLog(@"_text: %@", _text);
        
        if (!isStringEmpty(_text))
        {
            _label.text = _text;
            [self setAvtive:YES];
        }
    }
}

- (void)setLabelStyle:(LabelStyle)styleID
{
    [self clearLabelStyle];
    
    switch (styleID)
    {
        case kShadow:
        {
            _label.shadowOffset = CGSizeMake(0.0f, 2.0f);
            _label.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
            _label.shadowBlur = 5.0f;

            break;
        }
        case kInnerShadow:
        {
            _label.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
            _label.shadowOffset = CGSizeMake(1.0f, 1.0f);
            _label.shadowBlur = 2.0f;
            _label.innerShadowBlur = 2.0f;
            _label.innerShadowColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
            _label.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
            
            break;
        }
        case kGradientFill:
        {
            _label.gradientStartColor = [UIColor yellowColor];
            _label.gradientEndColor = [UIColor whiteColor];
            
            break;
        }
        case kMultiPartGradient:
        {
            _label.gradientStartPoint = CGPointMake(0.0f, 0.0f);
            _label.gradientEndPoint = CGPointMake(1.0f, 1.0f);
            _label.gradientColors = @[[UIColor redColor],
                                           [UIColor yellowColor],
                                           [UIColor greenColor],
                                           [UIColor cyanColor],
                                           [UIColor blueColor],
                                           [UIColor purpleColor],
                                           [UIColor redColor]];
            
            break;
        }
        case kSynthesis:
        {
            _label.shadowColor = [UIColor blackColor];
            _label.shadowOffset = kShadowOffset;
            _label.shadowBlur = kShadowBlur;
            _label.innerShadowBlur = 2.0f;
            _label.innerShadowColor = [UIColor whiteColor];
            _label.innerShadowOffset = CGSizeMake(1.0f, 1.0f);
            _label.gradientStartColor = [UIColor redColor];
            _label.gradientEndColor = [UIColor yellowColor];
            _label.gradientStartPoint = CGPointMake(0.0f, 0.5f);
            _label.gradientEndPoint = CGPointMake(1.0f, 0.5f);
            _label.oversampling = 2;
            
            break;
        }
        default:
        {
            _label.shadowColor = kLightBlue;
            _label.shadowOffset = kShadowOffset;
            _label.shadowBlur = 10.0f;
            
            break;
        }
    }
    
    NSLog(@"setLabelStyle invoked");
}

- (LabelStyle)labelStyle
{
    return self.labelStyle;
}

- (void)clearLabelStyle
{
    _label.shadowColor = nil;
    _label.shadowOffset = CGSizeZero;
    _label.shadowBlur = 0.0f;
    _label.innerShadowBlur = 0.0f;
    _label.innerShadowColor = nil;
    _label.innerShadowOffset = CGSizeZero;
    _label.innerShadowBlur = 0.0f;
    
    _label.gradientStartColor = nil;
    _label.gradientEndColor = nil;
    _label.gradientStartPoint = CGPointMake(0.5f, 0.0f);
    _label.gradientEndPoint = CGPointMake(0.5f, 0.75f);
    _label.oversampling = 0;
}

#pragma mark- gesture events

- (void)pushedDeleteBtn:(id)sender
{
    CLTextView *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i)
    {
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[CLTextView class]])
        {
            nextTarget = (CLTextView*)view;
            break;
        }
    }
    
    if(nextTarget == nil)
    {
        for(NSInteger i=index-1; i>=0; --i)
        {
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[CLTextView class]])
            {
                nextTarget = (CLTextView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveTextView:nextTarget];
    [self removeFromSuperview];
}

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    if(self.active)
    {
        NSNotification *n = [NSNotification notificationWithName:CLTextViewActiveViewDidTapNotification object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:n waitUntilDone:NO];
    }
    [[self class] setActiveTextView:self];
}

- (void)viewDidDubleTap:(UITapGestureRecognizer*)sender
{
    if(self.active)
    {
        NSNotification *n = [NSNotification notificationWithName:CLTextViewActiveViewDidDoubleTapNotification object:self userInfo:nil];
        [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:n waitUntilDone:NO];
    }
    [[self class] setActiveTextView:self];
}


- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveTextView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = _initialArg + arg - tmpA;
    [self setScale:MAX(_initialScale * R / tmpR, 15/200.0)];
}

@end


