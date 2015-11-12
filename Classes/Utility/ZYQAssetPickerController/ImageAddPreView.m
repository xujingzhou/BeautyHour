
#import "ImageAddPreView.h"
#import "UIButton+Help.h"
#define D_Pending_Width     5

#define D_ImageEditView_Width   75+10
#define D_ImageEditView_Height   75+10
@implementation ImageAddPreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor redColor];
        [self initResource];
    }
    return self;
}

- (void)initResource
{
    _imageassets = [NSMutableArray array];
    _imageEditViewArray = [NSMutableArray array];
    
    self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    _selectBeforeLab = [[UILabel alloc] initWithFrame:CGRectMake(2*D_Pending_Width,
                                                                2*D_Pending_Width,
                                                                self.bounds.size.width - 100,
                                                                20)];
    [_selectBeforeLab setTextColor:[UIColor colorWithHexString:@"#c9c9c9"]];
    [_selectBeforeLab setFont:[UIFont systemFontOfSize:13.0f]];
    [self addSubview: _selectBeforeLab];
    [_selectBeforeLab setTextAlignment:NSTextAlignmentLeft];
    [_selectBeforeLab setText:D_LocalizedCardString(@"Choose")];
    
    _selectNumLab = [[UILabel alloc] initWithFrame:CGRectMake(2*D_Pending_Width,
                                                                2*D_Pending_Width,
                                                                self.bounds.size.width - 100,
                                                                20)];
    [_selectNumLab setTextColor:[UIColor colorWithHexString:@"#eb4d47"]];
    [_selectNumLab setTextAlignment:NSTextAlignmentCenter];
    
    [_selectNumLab setFont:[UIFont systemFontOfSize:13.0f]];
    [self addSubview: _selectNumLab];
    _selectafterLab = [[UILabel alloc] initWithFrame:CGRectMake(2*D_Pending_Width,
                                                                2*D_Pending_Width,
                                                                self.bounds.size.width - 100,
                                                                20)];
    [_selectafterLab setTextColor:[UIColor colorWithHexString:@"#c9c9c9"]];
    [_selectafterLab setFont:[UIFont systemFontOfSize:13.0f]];
    [self addSubview: _selectafterLab];
    [_selectafterLab setTextAlignment:NSTextAlignmentRight];
    [_selectafterLab setText:D_LocalizedCardString(@"PhotoCount")];
    
    int widthBtn = 70, heightBtn = 38;
    _startPintuButton =  [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - widthBtn - D_Pending_Width,
                                                                    D_Pending_Width,
                                                                    widthBtn,
                                                                    heightBtn)];
    [_startPintuButton setBackgroundColorNormal:[UIColor colorWithHexString:@"#1fbba6"] highlightedColor:[UIColor colorWithHexString:@"#03917e"]];
    [_startPintuButton setTitle:D_LocalizedCardString(@"card_meitu_complete") forState:UIControlStateNormal];
    [_startPintuButton addTarget:self action:@selector(startPintuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_startPintuButton.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
    [_startPintuButton.layer setCornerRadius:2.f];
    [_startPintuButton setClipsToBounds:YES];
    [self addSubview:_startPintuButton];
    
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                  44,
                                                                  self.bounds.size.width,
                                                                  D_ImageEditView_Height)];
    [self addSubview:_contentView];
    [self.selectNumLab setText:[NSString stringWithFormat:@"%lu",(unsigned long)[_imageassets count]]];
    [self reselectNumFrame];
}


- (void)addImageWith:(ALAsset *)asset
{
    if(_imageassets.count < 5)
    {
        [_imageassets addObject:asset];
        [self.selectNumLab setText:[NSString stringWithFormat:@"%lu",(unsigned long)[_imageassets count]]];
        [self reselectNumFrame];
        _contentView.contentSize = CGSizeMake([_imageassets count] *D_ImageEditView_Width, _contentView.frame.size.height);
        if ([_imageassets count]*(D_ImageEditView_Width+D_Pending_Width)+D_Pending_Width > _contentView.frame.size.width)
        {
            [self.contentView setContentOffset:CGPointMake(self.contentView.contentSize.width - _contentView.frame.size.width, 0) animated:YES];
        }
        ImageEditView *editView = [[ImageEditView alloc] initWithFrame:CGRectMake([_imageassets count]*(D_ImageEditView_Width+D_Pending_Width)+D_Pending_Width,
                                                                                  0,
                                                                                  D_ImageEditView_Width,
                                                                                  D_ImageEditView_Width)];
        [editView setImageAsset:asset index:[_imageassets count]-1];
        editView.deleteEdit = self;
        [_imageEditViewArray addObject:editView];
        [_contentView addSubview:editView];
            
        [self resetContentView];
            
        if ([_imageassets count]*(D_ImageEditView_Width+D_Pending_Width)+D_Pending_Width > _contentView.frame.size.width)
        {
            [self.contentView setContentOffset:CGPointMake(self.contentView.contentSize.width - _contentView.frame.size.width, 0) animated:YES];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:D_LocalizedCardString(@"card_meitu_max_image_prompt")
                                                        message:D_LocalizedCardString(@"card_meitu_max_image_prompttext")
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:D_LocalizedCardString(@"card_meitu_max_image_promptDetermine"), nil];
            [alert show];
    }

}

- (void)deletePintuAction:(ALAsset *)asset
{
    for (ImageEditView *tempEditView in _imageEditViewArray)
    {
        if ([tempEditView.asset.defaultRepresentation.url isEqual:asset.defaultRepresentation.url])
        {
            [self responseToDelete:tempEditView];
            break;
        }
    }
    [self resetContentView];
}

- (void)startPintuButtonAction:(id)sender
{
    if (_delegateSelectImage && [_delegateSelectImage respondsToSelector:@selector(startPintuAction:)])
    {
        [_delegateSelectImage startPintuAction:self];
    }
}

#pragma mark
#pragma mark ImageEditViewDelegate
- (void)responseToDelete:(id)sender
{
    ImageEditView *imageEditView  = (ImageEditView *)sender;
    [imageEditView removeFromSuperview];
    [_imageEditViewArray removeObject:imageEditView];
    [_imageassets removeObjectAtIndex:imageEditView.index];
    [self resetContentView];
}

- (void)resetContentView
{
    for (int i = 0; i < [_imageassets count]; i++)
    {
        ImageEditView *tempEditView = [_imageEditViewArray objectAtIndex:i];
        tempEditView.index = i;
        [UIView animateWithDuration:0.2
                              delay:0.1
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             tempEditView.frame = CGRectMake(i*(D_ImageEditView_Width+D_Pending_Width)+D_Pending_Width,
                                                             0,
                                                             D_ImageEditView_Width,
                                                             D_ImageEditView_Width);
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    
    _contentView.contentSize = CGSizeMake([_imageassets count]*(D_ImageEditView_Width+D_Pending_Width)+D_Pending_Width, _contentView.frame.size.height);
    
    [self.selectNumLab setText:[NSString stringWithFormat:@"%lu",(unsigned long)[_imageassets count]]];
    [self reselectNumFrame];
}

- (void)reselectNumFrame
{
    CGRect rect = self.selectBeforeLab.frame;
    CGSize size = [self.selectBeforeLab.text sizeWithFont:self.selectBeforeLab.font constrainedToSize:CGSizeMake(self.frame.size.width, rect.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    rect.size.width = size.width;
    self.selectBeforeLab.frame = rect;
    
    rect = self.selectNumLab.frame;
    rect.origin.x = self.selectBeforeLab.frame.origin.x +self.selectBeforeLab.frame.size.width;
    size = [self.selectNumLab.text sizeWithFont:self.selectNumLab.font constrainedToSize:CGSizeMake(self.frame.size.width, rect.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    rect.size.width = size.width;
    self.selectNumLab.frame = rect;
    
    rect = self.selectafterLab.frame;
    rect.origin.x = self.selectNumLab.frame.origin.x +self.selectNumLab.frame.size.width;
    size = [self.selectafterLab.text sizeWithFont:self.selectafterLab.font constrainedToSize:CGSizeMake(self.frame.size.width, rect.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    rect.size.width = size.width;
    self.selectafterLab.frame = rect;
}

- (void)reMoveAllResource
{
    [self.imageassets removeAllObjects];
    [self.imageEditViewArray removeAllObjects];
    
    for (UIView *v in  self.contentView.subviews)
    {
        [v removeFromSuperview];
    }
    
    [self resetContentView];
}

#pragma mark - Loading View

- (void)showWaitView
{
    [LoadingViewManager showLoadViewWithText:D_LocalizedCardString(@"Video_Processing") andShimmering:YES andBlurEffect:YES inView:self];
    
    NSLog(@"showWaitView");
}

- (void)hiddenWaitView
{
    [[LoadingViewManager sharedInstance] removeLoadingView:self];
    
    NSLog(@"hiddenWaitView");
}

@end
