

#import "MeituImageEditView.h"

#define MRScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define MRScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)

@interface MeituImageEditView (Utility)

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation MeituImageEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        [self initImageView];
    }
    return self;
}

- (void)initImageView
{
    self.backgroundColor = [UIColor grayColor];
    
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectInset(self.bounds, 0, 0)];
    _contentView.delegate = self;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.showsVerticalScrollIndicator = NO;
    [self addSubview:_contentView];

    
    self.imageview = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageview.frame = CGRectMake(0, 0, MRScreenWidth * 2.5, MRScreenWidth * 2.5);
    _imageview.userInteractionEnabled = YES;
//    [_imageview setClipsToBounds:YES];
//    _imageview.contentMode = UIViewContentModeScaleAspectFit;
    [_contentView addSubview:_imageview];
    
    // Add gesture,double tap zoom imageView.
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [_imageview addGestureRecognizer:doubleTapGesture];
    [doubleTapGesture release];
    
    float minimumScale = self.frame.size.width / _imageview.frame.size.width;
    [_contentView setMinimumZoomScale:minimumScale];
    [_contentView setZoomScale:minimumScale];
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}



- (void)setImageViewData:(UIImage *)imageData
{
    _imageview.image = imageData;
    if (imageData == nil)
    {
        return;
    }
    
    CGRect rect  = CGRectZero;
    CGFloat scale = 1.0f;
    CGFloat w = 0.0f;
    CGFloat h = 0.0f;
    if(self.contentView.frame.size.width > self.contentView.frame.size.height)
    {
        
        w = self.contentView.frame.size.width;
        h = w*imageData.size.height/imageData.size.width;
        if(h < self.contentView.frame.size.height){
            h = self.contentView.frame.size.height;
            w = h*imageData.size.width/imageData.size.height;
        }
        
    }
    else
    {
    
        h = self.contentView.frame.size.height;
        w = h*imageData.size.width/imageData.size.height;
        if(w < self.contentView.frame.size.width)
        {
            w = self.contentView.frame.size.width;
            h = w*imageData.size.height/imageData.size.width;
        }
    }
    rect.size = CGSizeMake(w, h);
    
    CGFloat scale_w = w / imageData.size.width;
    CGFloat scale_h = h / imageData.size.height;
    if (w > self.frame.size.width || h > self.frame.size.height)
    {
        scale_w = w / self.frame.size.width;
        scale_h = h / self.frame.size.height;
        if (scale_w > scale_h)
        {
            scale = 1/scale_w;
        }
        else
        {
            scale = 1/scale_h;
        }
    }
    
    if (w <= self.frame.size.width || h <= self.frame.size.height)
    {
        scale_w = w / self.frame.size.width;
        scale_h = h / self.frame.size.height;
        if (scale_w > scale_h)
        {
            scale = scale_h;
        }
        else
        {
            scale = scale_w;
        }
    }
    
    @synchronized(self)
    {
        _imageview.frame = rect;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [self.realCellArea CGPath];
        maskLayer.fillColor = [[UIColor whiteColor] CGColor];
        maskLayer.frame = _imageview.frame;
        self.layer.mask = maskLayer;
        
        [_contentView setZoomScale:0.2 animated:YES];
        
        [self setNeedsLayout];
        
    }
    
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    
    BOOL contained=[_realCellArea containsPoint:point];
    if(_tapDelegate && [_tapDelegate respondsToSelector:@selector(tapWithEditView:)])
    {
        [_tapDelegate tapWithEditView:nil];
    }
    return contained;
}


#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    float newScale = _contentView.zoomScale * 1.2;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:_imageview]];
    [_contentView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    if (scale == 0)
    {
        scale = 1;
    }
    
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageview;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    
    [scrollView setZoomScale:scale animated:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    return;
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    return;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{


}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{


}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    self.imageview.center = touch;
    
}

#pragma mark - View cycle
- (void)dealloc
{
    [_contentView release];
    [_realCellArea release];
    [_imageview release];
    
    _contentView = nil;
    _realCellArea = nil;
    _imageview = nil;
    [super dealloc];
}

@end
