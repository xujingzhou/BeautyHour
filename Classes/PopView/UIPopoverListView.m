
#import "UIPopoverListView.h"
#import <QuartzCore/QuartzCore.h>

//#define FRAME_X_INSET 20.0f
//#define FRAME_Y_INSET 40.0f

@interface UIPopoverListView ()

- (void)defalutInit;
- (void)fadeIn;
- (void)fadeOut;

@end

@implementation UIPopoverListView

@synthesize datasource = _datasource;
@synthesize delegate = _delegate;

@synthesize listView = _listView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self defalutInit];
    }
    return self;
}

- (void)defalutInit
{
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = TRUE;
    
    NSString *fontName = D_LocalizedCardString(@"FontName");
    CGFloat fontSize = 18;
    CGFloat titleHeight = 40.0f;
    _titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleView.font = [UIFont fontWithName:fontName size:fontSize];
    _titleView.backgroundColor = [UIColor colorWithRed:59./255.
                                                 green:89./255.
                                                  blue:152./255.
                                                 alpha:1.0f];
    
    _titleView.textAlignment = NSTextAlignmentCenter;
    _titleView.textColor = [UIColor whiteColor];
    CGFloat xWidth = self.bounds.size.width;
    _titleView.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleView.frame = CGRectMake(0, 0, xWidth, titleHeight);
    [self addSubview:_titleView];
    
    // Change color
//    _titleView.userInteractionEnabled = TRUE;
//    [self initColorButton];
//    [self initDoneButton];
    
    CGRect tableFrame = CGRectMake(0, titleHeight, xWidth, self.bounds.size.height-titleHeight);
    _listView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _listView.dataSource = self;
    _listView.delegate = self;
    [self addSubview:_listView];
    
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    [_overlayView addTarget:self
                     action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
}

- (void)initColorButton
{
    int buttonWidth = 50;
    int kStartLocation = 6;
    UIButton *colorButton  = [[UIButton alloc] initWithFrame:CGRectMake(_titleView.frame.origin.x + kStartLocation, _titleView.frame.origin.y + kStartLocation/2, buttonWidth, _titleView.bounds.size.height - kStartLocation/2)];
    [colorButton setBackgroundImage:[UIImage imageNamed:@"home_block_green_a"] forState:UIControlStateNormal];
    [colorButton setTitle:D_LocalizedCardString(@"Color") forState:UIControlStateNormal];
    [colorButton setClipsToBounds:YES];
    
    CGFloat fontSize = 16;
    [colorButton.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [colorButton addTarget:self action:@selector(changeColor) forControlEvents:UIControlEventTouchUpInside];
    
    [_titleView addSubview:colorButton];
}

- (void)initDoneButton
{
    int buttonWidth = 50;
    int kStartLocation = 6;
    UIButton *doneButton  = [[UIButton alloc] initWithFrame:CGRectMake(_titleView.bounds.size.width - buttonWidth - kStartLocation, _titleView.frame.origin.y + kStartLocation/2, buttonWidth, _titleView.bounds.size.height - kStartLocation/2)];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"home_block_green_a"] forState:UIControlStateNormal];
    [doneButton setTitle:D_LocalizedCardString(@"Done") forState:UIControlStateNormal];
    [doneButton setClipsToBounds:YES];
    
    CGFloat fontSize = 16;
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [doneButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [_titleView addSubview:doneButton];
}

- (void)changeColor
{
    // Color Picker
    if(self.delegate && [self.delegate respondsToSelector:@selector(popoverColorPicker)])
    {
        [self dismiss];
        return [self.delegate popoverColorPicker];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.datasource &&
       [self.datasource respondsToSelector:@selector(popoverListView:numberOfRowsInSection:)])
    {
        return [self.datasource popoverListView:self numberOfRowsInSection:section];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.datasource &&
       [self.datasource respondsToSelector:@selector(popoverListView:cellForIndexPath:)])
    {
        return [self.datasource popoverListView:self cellForIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(popoverListView:heightForRowAtIndexPath:)])
    {
        return [self.delegate popoverListView:self heightForRowAtIndexPath:indexPath];
    }
    
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate &&
       [self.delegate respondsToSelector:@selector(popoverListView:didSelectIndexPath:)])
    {
        [self.delegate popoverListView:self didSelectIndexPath:indexPath];
    }
    
    [self dismiss];
}


#pragma mark - animations

- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_overlayView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (void)setTitle:(NSString *)title
{
    _titleView.text = title;
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

#define mark - UITouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tell the delegate the cancellation
    if (self.delegate && [self.delegate respondsToSelector:@selector(popoverListViewCancel:)])
    {
        [self.delegate popoverListViewCancel:self];
    }
    
    // dismiss self
    [self dismiss];
}


//
// draw round rect corner
//
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef c = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(c, [[UIColor whiteColor] CGColor]);
//    CGContextSetStrokeColorWithColor(c, [[UIColor blackColor] CGColor]);
//
//    CGContextBeginPath(c);
//    addRoundedRectToPath(c, rect, 10.0f, 10.0f);
//    CGContextFillPath(c);
//
//    CGContextSetLineWidth(c, 1.0f);
//    CGContextBeginPath(c);
//    addRoundedRectToPath(c, rect, 10.0f, 10.0f);
//    CGContextStrokePath(c);
//}
//
//
//static void addRoundedRectToPath(CGContextRef context, CGRect rect,
//								 float ovalWidth,float ovalHeight)
//{
//    float fw, fh;
//
//    if (ovalWidth == 0 || ovalHeight == 0) {// 1
//        CGContextAddRect(context, rect);
//        return;
//    }
//
//    CGContextSaveGState(context);// 2
//
//    CGContextTranslateCTM (context, CGRectGetMinX(rect),// 3
//						   CGRectGetMinY(rect));
//    CGContextScaleCTM (context, ovalWidth, ovalHeight);// 4
//    fw = CGRectGetWidth (rect) / ovalWidth;// 5
//    fh = CGRectGetHeight (rect) / ovalHeight;// 6
//
//    CGContextMoveToPoint(context, fw, fh/2); // 7
//    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);// 8
//    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);// 9
//    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);// 10
//    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
//    CGContextClosePath(context);// 12
//
//    CGContextRestoreGState(context);// 13
//}

@end
