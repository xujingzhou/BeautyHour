//  GLStoryboardSelectView
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//
#import "GLStoryboardSelectView.h"

static NSMutableDictionary *filenameDic;

@interface GLStoryboardSelectView()

@property (nonatomic, strong) UIButton *selectedStoryboardBtn;

@end

@implementation GLStoryboardSelectView

#pragma mark - Puzzle
- (id)initWithFrameFromPuzzle:(CGRect)frame picCount:(NSInteger)picCount
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        self.picCount = picCount;
        [self initResourceFormPuzzle];
    }
    return self;
}

- (void)initResourceFormPuzzle
{
    _storyboardView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [_storyboardView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.6]];
    _storyboardView.showsHorizontalScrollIndicator = NO;
    _storyboardView.showsVerticalScrollIndicator = NO;
    [self addSubview:_storyboardView];
    
    CGFloat width = 116/2.0f;
    CGFloat height = 100/2.0f;
    
    NSArray *imageNameArray = nil;
    
    switch (self.picCount)
    {
        case 2:
            imageNameArray = [NSArray arrayWithObjects:@"makecards_puzzle_storyboard1_icon",
                                @"makecards_puzzle_storyboard2_icon",
                                @"makecards_puzzle_storyboard3_icon",
                                @"makecards_puzzle_storyboard4_icon",
                                @"makecards_puzzle_storyboard5_icon",
                                @"makecards_puzzle_storyboard6_icon",nil];
            break;
        case 3:
            imageNameArray = [NSArray arrayWithObjects:@"makecards_puzzle3_storyboard1_icon",
                              @"makecards_puzzle3_storyboard2_icon",
                              @"makecards_puzzle3_storyboard3_icon",
                              @"makecards_puzzle3_storyboard4_icon",
                              @"makecards_puzzle3_storyboard5_icon",
                              @"makecards_puzzle3_storyboard6_icon",nil];
            break;
        case 4:
            imageNameArray = [NSArray arrayWithObjects:@"makecards_puzzle4_storyboard1_icon",
                              @"makecards_puzzle4_storyboard2_icon",
                              @"makecards_puzzle4_storyboard3_icon",
                              @"makecards_puzzle4_storyboard4_icon",
                              @"makecards_puzzle4_storyboard5_icon",
                              @"makecards_puzzle4_storyboard6_icon",nil];
            break;
        case 5:
            imageNameArray = [NSArray arrayWithObjects:@"makecards_puzzle5_storyboard1_icon",
                              @"makecards_puzzle5_storyboard2_icon",
                              @"makecards_puzzle5_storyboard3_icon",
                              @"makecards_puzzle5_storyboard4_icon",
                              @"makecards_puzzle5_storyboard5_icon",
                              @"makecards_puzzle5_storyboard6_icon",nil];
            break;
        default:
            break;
    }
    
    for (int i = 0; i < [imageNameArray count]; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*width+(width-37)/2.0f, 2.5f, 37, 45)];
        [button setImage:[UIImage imageNamed:[imageNameArray objectAtIndex:i]] forState:UIControlStateNormal];
        
        UIEdgeInsets insets = {3, 3, 3, 3};
        [button setImageEdgeInsets:insets];
        
        [button setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(storyboardAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i+1];
        [_storyboardView addSubview:button];
        
        if (i==0)
        {
            [button setSelected:YES];
            _selectedStoryboardBtn = button;
        }
    }
    
    [_storyboardView setContentSize:CGSizeMake([imageNameArray count]*width, height)];
}

- (void)storyboardAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button == _selectedStoryboardBtn)
    {
        return;
    }
    
    self.selectStyleIndex = button.tag;
    [_selectedStoryboardBtn setSelected:NO];
    _selectedStoryboardBtn = button;
    [_selectedStoryboardBtn setSelected:YES];
    
    if (_delegateSelect && [_delegateSelect respondsToSelector:@selector(didSelectedStoryboardPicCount:styleIndex:)])
    {
        [_delegateSelect didSelectedStoryboardPicCount:self.picCount styleIndex:self.selectStyleIndex];
    }
}

#pragma mark - Border
- (id)initWithFrameFromBorder:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        [self initResourceFormBorder];
    }
    return self;
}

- (void)initResourceFormBorder
{
    _storyboardView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [_storyboardView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.6]];
    _storyboardView.showsHorizontalScrollIndicator = NO;
    _storyboardView.showsVerticalScrollIndicator = NO;
    [self addSubview:_storyboardView];
    
    // Get files count from resource
    NSString *filename = @"border";
    NSArray *fileList = [filenameDic objectForKey:filename];
    NSLog(@"fileList: %@, Count: %lu", fileList, (unsigned long)[fileList count]);
    
    unsigned long borderCount = [fileList count] + 1;
    CGFloat width = 116/2.0f;
    CGFloat height = 100/2.0f;
    for (int i = 0; i < borderCount; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*width+(width-37)/2.0f, 2.5f, 37, 45)];
        if (i == 0)
        {
            [button setImage:[UIImage imageNamed:@"themeOriginal"] forState:UIControlStateNormal];
        }
        else
        {
            NSString *imageName = [NSString stringWithFormat:@"border_%i", i];
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
        
        UIEdgeInsets insets = {3, 3, 3, 3};
        [button setImageEdgeInsets:insets];
        
        [button setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(borderAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        [_storyboardView addSubview:button];
        
        if (i==0)
        {
            [button setSelected:YES];
            _selectedStoryboardBtn = button;
        }
    }
    
    [_storyboardView setContentSize:CGSizeMake(borderCount*width, height)];
}

- (void)borderAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button == _selectedStoryboardBtn)
    {
        return;
    }
    
    self.selectStyleIndex = button.tag;
    [_selectedStoryboardBtn setSelected:NO];
    _selectedStoryboardBtn = button;
    [_selectedStoryboardBtn setSelected:YES];
    
    if (_delegateSelect && [_delegateSelect respondsToSelector:@selector(didSelectedBorderIndex:)])
    {
        [_delegateSelect didSelectedBorderIndex:self.selectStyleIndex];
    }
}

#pragma mark - Filter
- (id)initWithFrameFromFilter:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        [self initResourceFormFilter];
    }
    return self;
}

- (void)initResourceFormFilter
{
    _storyboardView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [_storyboardView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.6]];
    _storyboardView.showsHorizontalScrollIndicator = NO;
    _storyboardView.showsVerticalScrollIndicator = NO;
    [self addSubview:_storyboardView];
    
    // Get files count from resource
    NSString *filename = @"filter";
    NSArray *fileList = [filenameDic objectForKey:filename];
    NSLog(@"fileList: %@, Count: %lu", fileList, (unsigned long)[fileList count]);
    
    unsigned long borderCount = [fileList count] + 1;
    CGFloat width = 116/2.0f;
    CGFloat height = 100/2.0f;
    for (int i = 0; i < borderCount; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*width+(width-37)/2.0f, 2.5f, 37, 45)];
        if (i == 0)
        {
            [button setImage:[UIImage imageNamed:@"themeOriginal"] forState:UIControlStateNormal];
        }
        else
        {
            NSString *imageName = [NSString stringWithFormat:@"filter_%i.JPG", i];
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
        
        UIEdgeInsets insets = {3, 3, 3, 3};
        [button setImageEdgeInsets:insets];
        
        [button setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        [_storyboardView addSubview:button];
        
        if (i==0)
        {
            [button setSelected:YES];
            _selectedStoryboardBtn = button;
        }
    }
    
    [_storyboardView setContentSize:CGSizeMake(borderCount*width, height)];
}

- (void)filterAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button == _selectedStoryboardBtn)
    {
        return;
    }
    
    self.selectStyleIndex = button.tag;
    [_selectedStoryboardBtn setSelected:NO];
    _selectedStoryboardBtn = button;
    [_selectedStoryboardBtn setSelected:YES];
    
    if (_delegateSelect && [_delegateSelect respondsToSelector:@selector(didSelectedFilterIndex:)])
    {
        [_delegateSelect didSelectedFilterIndex:self.selectStyleIndex];
    }
}

#pragma mark - Sticker
- (id)initWithFrameFromSticker:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        [self initResourceFormSticker];
    }
    return self;
}

- (void)initResourceFormSticker
{
    _storyboardView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [_storyboardView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.6]];
    _storyboardView.showsHorizontalScrollIndicator = NO;
    _storyboardView.showsVerticalScrollIndicator = NO;
    [self addSubview:_storyboardView];
    
    // Get files count from resource
//    NSString *filename = @"sticker";
//    NSArray *fileList = [filenameDic objectForKey:filename];
//    NSLog(@"fileList: %@, Count: %lu", fileList, (unsigned long)[fileList count]);
    
//    unsigned long borderCount = [fileList count];
    unsigned long borderCount = 25;
    CGFloat width = 116/2.0f;
    CGFloat height = 100/2.0f;
    for (int i = 0; i < borderCount; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*width+(width-37)/2.0f, 2.5f, 45, 45)];
        NSString *imageName = [NSString stringWithFormat:@"sticker_%i", i+1];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        UIEdgeInsets insets = {3, 3, 3, 3};
        [button setImageEdgeInsets:insets];
        
        [button setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(stickerAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i+1];
        [_storyboardView addSubview:button];
        
        if (i==0)
        {
            [button setSelected:YES];
            _selectedStoryboardBtn = button;
        }
    }
    
    [_storyboardView setContentSize:CGSizeMake(borderCount*width, height)];
}

- (void)stickerAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button == _selectedStoryboardBtn)
    {
        return;
    }
    
    self.selectStyleIndex = button.tag;
    [_selectedStoryboardBtn setSelected:NO];
    _selectedStoryboardBtn = button;
    [_selectedStoryboardBtn setSelected:YES];
    
    if (_delegateSelect && [_delegateSelect respondsToSelector:@selector(didSelectedStickerIndex:)])
    {
        [_delegateSelect didSelectedStickerIndex:self.selectStyleIndex];
    }
}

#pragma mark - Face
- (id)initWithFrameFromFace:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        [self initResourceFormFace];
    }
    return self;
}

- (void)initResourceFormFace
{
    _storyboardView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [_storyboardView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.6]];
    _storyboardView.showsHorizontalScrollIndicator = NO;
    _storyboardView.showsVerticalScrollIndicator = NO;
    [self addSubview:_storyboardView];
    
    // Get files count from resource
    NSString *filename = @"face";
    NSArray *fileList = [filenameDic objectForKey:filename];
    NSLog(@"fileList: %@, Count: %lu", fileList, (unsigned long)[fileList count]);
    
    unsigned long borderCount = [fileList count];
    CGFloat width = 116/2.0f;
    CGFloat height = 100/2.0f;
    for (int i = 0; i < borderCount; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*width+(width-37)/2.0f, 2.5f, 45, 45)];
        NSString *imageName = [NSString stringWithFormat:@"face_%i", i+1];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        UIEdgeInsets insets = {3, 3, 3, 3};
        [button setImageEdgeInsets:insets];
        
        [button setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(faceAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i+1];
        [_storyboardView addSubview:button];
        
        if (i==0)
        {
            [button setSelected:YES];
            _selectedStoryboardBtn = button;
        }
    }
    
    [_storyboardView setContentSize:CGSizeMake(borderCount*width, height)];
}

- (void)faceAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button == _selectedStoryboardBtn)
    {
        return;
    }
    
    self.selectStyleIndex = button.tag;
    [_selectedStoryboardBtn setSelected:NO];
    _selectedStoryboardBtn = button;
    [_selectedStoryboardBtn setSelected:YES];
    
    if (_delegateSelect && [_delegateSelect respondsToSelector:@selector(didSelectedFaceIndex:)])
    {
        [_delegateSelect didSelectedFaceIndex:self.selectStyleIndex];
    }
}

#pragma mark - Blur Background
- (id)initWithFrameFromBlurBackground:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        [self initResourceFormBlurBackground];
    }
    return self;
}

- (void)initResourceFormBlurBackground
{
    _storyboardView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [_storyboardView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.6]];
    _storyboardView.showsHorizontalScrollIndicator = NO;
    _storyboardView.showsVerticalScrollIndicator = NO;
    [self addSubview:_storyboardView];
    
    unsigned long borderCount = 3;
    CGFloat width = 116/2.0f;
    CGFloat height = 100/2.0f;
    for (int i = 0; i < borderCount; i++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*width+(width-37)/2.0f, 2.5f, 45, 45)];
        if (i == 0)
        {
            [button setImage:[UIImage imageNamed:@"themeOriginal"] forState:UIControlStateNormal];
        }
        else if (i == 1)
        {
            NSString *imageName = @"btn_circle_white";
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
        else if (i == 2)
        {
            NSString *imageName = @"btn_band_white";
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
        
        UIEdgeInsets insets = {3, 3, 3, 3};
        [button setImageEdgeInsets:insets];
        
        [button setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(blurBackgroundAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        [_storyboardView addSubview:button];
        
        if (i==0)
        {
            [button setSelected:YES];
            _selectedStoryboardBtn = button;
        }
    }
    
    [_storyboardView setContentSize:CGSizeMake(borderCount*width, height)];
}

- (void)blurBackgroundAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button == _selectedStoryboardBtn)
    {
        return;
    }
    
    self.selectStyleIndex = button.tag;
    [_selectedStoryboardBtn setSelected:NO];
    _selectedStoryboardBtn = button;
    [_selectedStoryboardBtn setSelected:YES];
    
    if (_delegateSelect && [_delegateSelect respondsToSelector:@selector(didSelectedBlueBackgroundIndex:)])
    {
        [_delegateSelect didSelectedBlueBackgroundIndex:self.selectStyleIndex];
    }
}

#pragma mark - Private Methods
+ (void)getDefaultFilelist
{
    NSString *name = @"face_1", *type = @"png";
    NSString *fileFullPath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSString *filePathWithoutName = [fileFullPath stringByDeletingLastPathComponent];
    NSString *fileName = [fileFullPath lastPathComponent];
    NSString *fileExt = [fileFullPath pathExtension];
    NSLog(@"filePathWithoutName: %@, fileName: %@, fileExt: %@", filePathWithoutName, fileName, fileExt);
    
    NSString *filenameByFace = @"face";
//    NSString *filenameBySticker = @"sticker";
    NSString *filenameByFilter = @"filter";
    NSString *filenameByBorder = @"border";
    filenameDic = [NSMutableDictionary dictionaryWithCapacity:4];
    [filenameDic setObject:getFilelistBySymbol(filenameByFace, filePathWithoutName) forKey:filenameByFace];
//    [filenameDic setObject:getFilelistBySymbol(filenameBySticker, filePathWithoutName) forKey:filenameBySticker];
    [filenameDic setObject:getFilelistBySymbol(filenameByFilter, filePathWithoutName) forKey:filenameByFilter];
    [filenameDic setObject:getFilelistBySymbol(filenameByBorder, filePathWithoutName) forKey:filenameByBorder];
}

@end
