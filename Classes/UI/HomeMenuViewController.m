//  HomeMenuViewController
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//
#import "HomeMenuViewController.h"
#import "AppDelegate.h"
#import <StoreKit/StoreKit.h>
#import "GLStoryboardSelectView.h"
#import "FXLabel.h"
#import "CMPopTipView.h"

@interface HomeMenuViewController ()<SKStoreProductViewControllerDelegate, CMPopTipViewDelegate>
{
    CMPopTipView *_popTipView;
}

@end

@implementation HomeMenuViewController

#pragma mark - CMPopTipViewDelegate methods
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
}

- (void)initPopView
{
    NSArray *colorSchemes = [NSArray arrayWithObjects:
                             [NSArray arrayWithObjects:[NSNull null], [NSNull null], nil],
                             [NSArray arrayWithObjects:[UIColor colorWithRed:134.0/255.0 green:74.0/255.0 blue:110.0/255.0 alpha:1.0], [NSNull null], nil],
                             [NSArray arrayWithObjects:[UIColor darkGrayColor], [NSNull null], nil],
                             [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor darkTextColor], nil],
                             nil];
    NSArray *colorScheme = [colorSchemes objectAtIndex:foo4random()*[colorSchemes count]];
    UIColor *backgroundColor = [colorScheme objectAtIndex:0];
    UIColor *textColor = [colorScheme objectAtIndex:1];
    
    NSString *hint = D_LocalizedCardString(@"UsageHint");
    _popTipView = [[CMPopTipView alloc] initWithMessage:hint];
    _popTipView.delegate = self;
    if (backgroundColor && ![backgroundColor isEqual:[NSNull null]])
    {
        _popTipView.backgroundColor = backgroundColor;
    }
    if (textColor && ![textColor isEqual:[NSNull null]])
    {
        _popTipView.textColor = textColor;
    }
    
    if (IOS7)
    {
        _popTipView.preferredPointDirection = PointDirectionDown;
    }
    _popTipView.animation = arc4random() % 2;
    _popTipView.has3DStyle = FALSE;
    _popTipView.dismissTapAnywhere = YES;
    [_popTipView autoDismissAnimated:YES atTimeInterval:3.0];
    
    [_popTipView presentPointingAtView:_meituMenuButton inView:self.view animated:YES];
}

#pragma mark
#pragma mark AppStore Open

- (void) showAppInAppStore:(NSString *)_appId
{
    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
    if (isAllow != nil)
    {
        // > iOS6.0
        SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
        sKStoreProductViewController.delegate = self;
        [self presentViewController:sKStoreProductViewController
                           animated:YES
                         completion:nil];
        [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier: _appId}completionBlock:^(BOOL result, NSError *error)
         {
             if (error)
             {
                 NSLog(@"%@",error);
             }
             
         }];
    }
    else
    {
        // < iOS6.0
        NSString *appUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",_appId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
        
        //        UIWebView *callWebview = [[UIWebView alloc] init];
        //        NSURL *appURL =[NSURL URLWithString:appStore];
        //        [callWebview loadRequest:[NSURLRequest requestWithURL:appURL]];
        //        [self.view addSubview:callWebview];
    }
}

#pragma mark - SKStoreProductViewControllerDelegate

// Dismiss contorller
- (void) productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - View Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    _popTipView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initResource];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"] forBarMetrics:UIBarMetricsDefault];
    NSString *fontName = D_LocalizedCardString(@"FontName");
    CGFloat fontSize = 20;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor colorWithRed:1 green:1 blue:1 alpha:1], UITextAttributeTextColor,
                                                                     [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                                     [UIFont fontWithName:fontName size:fontSize], UITextAttributeFont,
                                                                     nil]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sharebg3"]];
    self.title = D_LocalizedCardString(@"card_meitu_title");
}

- (void)initResource
{
    int top = 44;
    int gap = 5;
    // Image
    UIImage *image = [UIImage imageNamed:@"icon_PhotoEffect"];
    _meituMenuButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - image.size.width)/2, (self.view.bounds.size.height/2 - image.size.height) - top, image.size.width, image.size.height)];
    [_meituMenuButton setImage:image forState:UIControlStateNormal];
    [_meituMenuButton addTarget:self action:@selector(meituAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_meituMenuButton];
    
    // Text
    CGFloat fontSize = 45;
    NSString *fontName = D_LocalizedCardString(@"FontName");
    FXLabel *label = [[FXLabel alloc] initWithFrame:CGRectMake(gap, _meituMenuButton.frame.origin.y + _meituMenuButton.frame.size.height, self.view.bounds.size.width - 2*gap, image.size.height)];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.minimumScaleFactor = 1/fontSize;
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = D_LocalizedCardString(@"PhotoEffects");
    
    label.shadowColor = kShadowColor1;
    label.shadowOffset = kShadowOffset;
    label.shadowBlur = kShadowBlur;
    label.innerShadowBlur = kInnerShadowBlur;
    label.innerShadowColor = kShadowColor2;
    label.innerShadowOffset = kInnerShadowOffset;
    label.gradientStartColor = kGradientStartColor;
    label.gradientEndColor = kGradientEndColor;
    label.gradientStartPoint = CGPointMake(0.0f, 0.5f);
    label.gradientEndPoint = CGPointMake(1.0f, 0.5f);
    label.oversampling = 2;
    [self.view addSubview:label];
    
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(meituAction:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [label addGestureRecognizer:singleRecognizer];
    
    
    // Recommend App
    UIButton *beautyHour = [[UIButton alloc] init];
    [beautyHour setTitle:D_LocalizedCardString(@"CustomBeauty")
                forState:UIControlStateNormal];
    
    UIButton *photoBeautify = [[UIButton alloc] init];
    [photoBeautify setTitle:D_LocalizedCardString(@"PhotoBeautify")
                   forState:UIControlStateNormal];
    
    UIButton *videoBeautify = [[UIButton alloc] init];
    [videoBeautify setTitle:D_LocalizedCardString(@"VideoBeautify")
                   forState:UIControlStateNormal];
    
    [photoBeautify setTag:1];
    [videoBeautify setTag:2];
    [beautyHour setTag:3];
    
    [self controlButtonStyleSettingWithButton:beautyHour];
    [self controlButtonStyleSettingWithButton:photoBeautify];
    [self controlButtonStyleSettingWithButton:videoBeautify];
    
    [self.view addSubview:photoBeautify];
    [self.view addSubview:videoBeautify];
    [self.view addSubview:beautyHour];
    
    // Init resourse
    [GLStoryboardSelectView getDefaultFilelist];
    
    // Guide 
    [self initPopView];
}

- (void)controlButtonStyleSettingWithButton:(UIButton *)sender
{
    int gap = 0;
    int height = 35;
    int top = self.view.frame.size.height - 44 - iOS7AddStatusHeight - height;
    sender.frame =  CGRectMake(self.view.frame.size.width/3.0f*(sender.tag-1) + gap, top, self.view.frame.size.width/3.0f, height);
    NSString *fontName = D_LocalizedCardString(@"FontName");
    CGFloat fontSize = 16;
    [sender.titleLabel setFont:[UIFont fontWithName:fontName size:fontSize]];
    
    [sender setTitleColor:[UIColor colorWithHexString:@"#1fbba6"] forState:UIControlStateNormal];
    [sender setTitleColor:kLightBlue forState:UIControlStateHighlighted];
    [sender setTitleColor:kLightBlue forState:UIControlStateSelected];
    [sender addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Action
- (void)bottomButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag)
    {
        case 1:
        {
            // Photo Beautify
            [self showAppInAppStore:@"919221990"];
            break;
        }
        case 2:
        {
            // Video Beautify
            [self showAppInAppStore:@"919102280"];
            break;
        }
        case 3:
        {
            // CustomBeauty
            [self showAppInAppStore:@"932192606"];
            break;
        }
        default:
            break;
    }
    
    [button setSelected:YES];
}

- (void)meituAction:(id)sender
{
    [self startPicker];
}

- (void)startPicker
{
    if (_picker == nil)
    {
        _picker = [[ZYQAssetPickerController alloc] init];
        _picker.maximumNumberOfSelection = 5;
        _picker.assetsFilter = [ALAssetsFilter allPhotos];
        _picker.showEmptyGroups = NO;
        _picker.delegate = self;
    }
    
    _picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                               {
                                   if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
                                   {
                                       NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                                       return duration >= 5;
                                   }
                                   else
                                   {
                                       return YES;
                                   }
                               }];
    
    [_picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar2"] forBarMetrics:UIBarMetricsDefault];
    NSString *fontName = D_LocalizedCardString(@"FontName");
    CGFloat fontSize = 20;
    [_picker.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:1 green:1 blue:1 alpha:1], UITextAttributeTextColor,
                                                   [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1], UITextAttributeTextShadowColor,
                                                   [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                   [UIFont fontWithName:fontName size:fontSize], UITextAttributeFont,
                                                   nil]];
    _picker.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sharebg3"]];
    
    [D_Main_Appdelegate showPreView];
    _picker.vc = self;
    [self presentViewController:_picker animated:YES completion:NULL];
    [D_Main_Appdelegate preview].delegateSelectImage = self;
    [[D_Main_Appdelegate preview] reMoveAllResource];
}

#pragma mark
#pragma mark ZYQAssetPickerControllerDelegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
}

#pragma mark
#pragma mark ImageAddPreViewDelegate
- (void)deletePintuAction:(ImageAddPreView *)sender
{
    
}

- (void)startPintuAction:(ImageAddPreView *)sender
{
    if ([sender.imageassets count] >= 1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoadingViewManager showLoadViewWithText:D_LocalizedCardString(@"Video_Processing") andShimmering:YES andBlurEffect:YES inView:self.view];
        });
        
        MeituEditStyleViewController *meituEditVC = [[MeituEditStyleViewController alloc] init];
        meituEditVC.assets = sender.imageassets;
        
        if (!meituEditVC.assetsImage)
        {
            meituEditVC.assetsImage = [[NSMutableArray alloc] initWithCapacity:1];
        }
        else
        {
            [meituEditVC.assetsImage removeAllObjects];
        }
        // Add images
        for (ALAsset *asset in sender.imageassets)
        {
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [meituEditVC.assetsImage addObject:image];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoadingViewManager hideLoadViewInView:self.view];
        });
        
        [_picker pushViewController:meituEditVC animated:YES];
    }
    else if([sender.imageassets count] == 1)
    {
    }
    else
    {
        UIAlertView *imageCountWarningalert = [[UIAlertView alloc] initWithTitle:nil
                                                                         message:D_LocalizedCardString(@"card_meitu_max_image_count_less_than_two")
                                                                        delegate:self
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:D_LocalizedCardString(@"card_meitu_max_image_promptDetermine"), nil];
        [imageCountWarningalert show];
        
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end