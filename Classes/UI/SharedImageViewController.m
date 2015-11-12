//  SharedImageViewController
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//
#import "SharedImageViewController.h"
#import "SUIModalActionSheet.h"
#import <Social/Social.h>
#import "JGActionSheet.h"
#import "QHBannerMenuView.h"
#import "FXLabel.h"
#import "UIImage+Utility.h"
#import "UIView+Frame.h"
#import "CLBlurBand.h"
#import "CLBlurCircle.h"
#import "CLSpotCircle.h"
#import "MarqueeLabel.h"
#import <Accelerate/Accelerate.h>

@interface SharedImageViewController ()<UIAlertViewDelegate, QHBannerMenuViewDelegate, UIGestureRecognizerDelegate>
{
    // Banner Menu
    NSArray *_bannerMenu;
    
    CLBlurCircle *_circleView;
    CLBlurBand *_bandView;
    CLSpotCircle *_spotLightView;
    CGFloat _X;
    CGFloat _Y;
    CGFloat _R;
    
    UIImage *_blurImage;
    CGRect _bandImageRect;
    CLBlurType _blurType;
}

@property (nonatomic, assign) long long recordResourceId;

@property (nonatomic, strong) QHBannerMenuView *bannerMenuView;

@end

@implementation SharedImageViewController

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    switch (alertView.tag)
    {
        case TWITTER_ALERTVIEW_TAG:
        {
            switch (buttonIndex)
            {
                case 0:
                {
                    NSLog(@"Clicked first button.");
                    
                    [self openTwitterSetting];
                    break;
                }
                case 1:
                {
                    NSLog(@"Clicked second button.");
                    
                    [alertView dismissWithClickedButtonIndex:0 animated:YES];
                    break;
                }
            }
            break;
        }
        case FACEBOOK_ALERTVIEW_TAG:
        {
            switch (buttonIndex)
            {
                case 0:
                {
                    NSLog(@"Clicked first button.");
                    break;
                }
                case 1:
                {
                    NSLog(@"Clicked second button.");
                    break;
                }
            }
            break;
        }
    }
}

#pragma mark - Private Methods
-(void)popAlert:(NSString*)content andTitle:(NSString*)title
{
    NSString *ok = D_LocalizedCardString(@"OK");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:content
                                                   delegate:self
                                          cancelButtonTitle:ok
                                          otherButtonTitles:nil];
    [alert setTag:COMMON_ALERTVIEW_TAG];
    [alert show];
}

-(void)popAlert:(NSString*)content andTitle:(NSString*)title andAnotherButton:(NSString*)anotherButton andTag:(NSInteger)tag
{
    NSString *cancel = D_LocalizedCardString(@"Button_Cancel");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:content
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:anotherButton, cancel, nil];
    [alert setTag:tag];
    [alert show];
}

-(UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Wechat
-(BOOL)isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}

-(void)shareWeixiFriendGroup:(enum WXScene) wxScene
{
    if (!self.image)
    {
        NSLog(@"Image is empty.");
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = D_LocalizedCardString(@"AppCreated");
    message.description = D_LocalizedCardString(@"AppDescription");
    
    UIImage *imageScale = [self scaleFromImage:self.image toSize:CGSizeMake(128, 128)];
    NSData *dataForJPEGFile = UIImageJPEGRepresentation(imageScale, 0.5);
    UIImage *image = [UIImage imageWithData: dataForJPEGFile];
    [message setThumbImage: image];
    
//    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl = D_LocalizedCardString(@"AppLink");
//    message.mediaObject = ext;
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(self.image, 0.8);
    ext.imageUrl = D_LocalizedCardString(@"AppLink");
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = wxScene;
    
    [WXApi sendReq:req];
}

#pragma mark - Sina Weibo
//- (WBMessageObject *)messageShareToSinaWeibo
//{
//    if (!self.image)
//    {
//        NSLog(@"Image is empty.");
//        return nil;
//    }
//    
//    WBMessageObject *message = [WBMessageObject message];
//    message.text = D_LocalizedCardString(@"AppDescription");
//    
//    WBImageObject *imageObject = [WBImageObject object];
//    imageObject.imageData = UIImageJPEGRepresentation(self.image, 0.8);
//    message.imageObject = imageObject;
//    
//    //    WBWebpageObject *webpage = [WBWebpageObject object];
//    //    NSString *id = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
//    //    webpage.objectID = id;
//    //    webpage.title = D_LocalizedCardString(@"AppCreated");
//    //    webpage.description = D_LocalizedCardString(@"AppDescription");
//    //
//    //    UIImage *imageScale = [self scaleFromImage:self.image toSize:CGSizeMake(128, 128)];
//    //    NSData *dataForJPEGFile = UIImageJPEGRepresentation(imageScale, 0.5);
//    //    webpage.thumbnailData = dataForJPEGFile;
//    //
//    //    // If image > 32K
//    //    if ([webpage.thumbnailData length] > 1024*32)
//    //    {
//    //        UIImage *imageScale = [self scaleFromImage:self.image toSize:CGSizeMake(64, 64)];
//    //        NSData *dataForJPEGFile = UIImageJPEGRepresentation(imageScale, 0.5);
//    //        webpage.thumbnailData = dataForJPEGFile;
//    //    }
//    //
//    //    webpage.webpageUrl = D_LocalizedCardString(@"AppLink");
//    //    message.mediaObject = webpage;
//    
//    return message;
//}
//
//- (void)ssoSinaWeibo
//{
//    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//    request.redirectURI = kWeiboRedirectURI;
//    request.scope = @"all";
//    request.userInfo = nil;
//    
//    [WeiboSDK sendRequest:request];
//}
//
//-(BOOL)isSinaWeiboAppInstalled
//{
//    return [WeiboSDK isWeiboAppInstalled];
//}
//
//#pragma mark - Sina Weibo delegate
//- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
//{
//    
//    NSLog(@"Sina Weibo share success: %@", result);
//}
//
//- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
//{
//    NSLog(@"Sina Weibo share failed: %@", [NSString stringWithFormat:@"%@",error]);
//}

#pragma mark - Share by Social Framework
- (BOOL)sharePhotoBySN:(NSString*)SNName
{
    BOOL bResult = FALSE;
    if([SLComposeViewController isAvailableForServiceType:SNName])
    {
        if (!self.image)
        {
            NSLog(@"Image is empty.");
            return bResult;
        }
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SNName];
        [controller setInitialText:D_LocalizedCardString(@"AppDescription")];
        [controller addURL:[NSURL URLWithString:D_LocalizedCardString(@"AppLink")]];
        
        UIImage *imageScale = [self scaleFromImage:self.image toSize:CGSizeMake(128, 128)];
        NSData *dataForJPEGFile = UIImageJPEGRepresentation(imageScale, 0.5);
        UIImage *image = [UIImage imageWithData: dataForJPEGFile];
        [controller addImage:image];
        
        bResult = TRUE;
        [self presentViewController:controller animated:YES completion:Nil];
    }
    
    return bResult;
}

- (void)openTwitterSetting
{
    
}

#pragma mark - Share
//- (void)sharePhotoBySinaWeibo
//{
//    if (self.image)
//    {
//        if (![self isSinaWeiboAppInstalled])
//        {
//            [self ssoSinaWeibo];
//        }
//        
//        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageShareToSinaWeibo]];
//        request.userInfo = nil;
//        
//        [WeiboSDK sendRequest:request];
//    }
//}

- (void)sharePhotoByWechat
{
    if (!self.image)
    {
        NSLog(@"Image is empty!");
        return;
    }
    
    if (![self isWXAppInstalled] || ![WXApi isWXAppSupportApi])
    {
        NSString *failed = D_LocalizedCardString(@"Failed");
        NSString *Error = D_LocalizedCardString(@"WeixiInstallError");
        [self popAlert:Error andTitle:failed];
        return;
    }
    
    [self shareWeixiFriendGroup:WXSceneTimeline];
}

- (BOOL)sharePhotoByTwitter
{
    return [self sharePhotoBySN:SLServiceTypeTwitter];
}

- (BOOL)sharePhotoByFacebook
{
    return [self sharePhotoBySN:SLServiceTypeFacebook];
}

- (void)sharePhotoByOthers
{
    NSString *title = D_LocalizedCardString(@"AppDescription");
    UIImage *imageScale = [self scaleFromImage:self.image toSize:CGSizeMake(128, 128)];
    NSData *dataForJPEGFile = UIImageJPEGRepresentation(imageScale, 0.5);
    UIImage *image = [UIImage imageWithData: dataForJPEGFile];
    NSURL *URL = [NSURL URLWithString:D_LocalizedCardString(@"AppLink")];
    NSArray *activityItems = [[NSArray alloc] initWithObjects:title, image, URL, nil];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeMessage];
    [self presentViewController:activityController animated:YES completion:nil];
    
    // https://devforums.apple.com/message/1049415#1049415
    if ([activityController respondsToSelector:@selector(popoverPresentationController)])
    {
        // iOS 8+
        UIPopoverPresentationController *presentationController = [activityController popoverPresentationController];
        presentationController.sourceView = self.view;
    }
}

#pragma mark - Banner Menu
- (void)initBannerMenu
{
    _bannerMenu = @[D_LocalizedCardString(@"Original"), D_LocalizedCardString(@"SpotLight"), D_LocalizedCardString(@"BlurCircular"), D_LocalizedCardString(@"BlurBand")];
    
    _bannerMenuView = [[QHBannerMenuView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44 - iOS7AddStatusHeight - (iPad?75:60), iPad?75:60, iPad?75:60) menuWidth:iPad?300:250 delegate:self];
    [self.view addSubview:_bannerMenuView];
}

#pragma mark - QHBannerMenuViewDelegate
- (NSInteger)bannerMenuView:(QHBannerMenuView *)bannerMenuView
{
    return _bannerMenu.count;
}

- (UIView *)bannerMenuView:(QHBannerMenuView *)bannerMenuView menuForRowAtIndexPath:(NSUInteger)index
{
    NSString *title = [_bannerMenu objectAtIndex:index];
    FXLabel *label  = [[FXLabel alloc] init];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = kShadowOffset;
    label.shadowBlur = kShadowBlur;
    label.textColor = [UIColor brownColor];
    
    CGFloat fontSize = 20;
    NSString *fontName = @"迷你简启体"; //@"yolan-yolan"; //
    label.font = [UIFont fontWithName:fontName size:fontSize];
    
    return label;
}

- (void)bannerMenuView:(QHBannerMenuView *)bannerMenuView didSelectRowAtIndexPath:(NSUInteger)index
{
    NSString *title = [_bannerMenu objectAtIndex:index];
    NSLog(@"Titile: %@, Index: %ld", title, (unsigned long)index);
    
    [_circleView removeFromSuperview];
    [_bandView removeFromSuperview];
    [_spotLightView removeFromSuperview];
    
    if (index == 1)
    {
        _blurType = KCLSpotLight;
        [_sharedImageView addSubview:_spotLightView];
        [_spotLightView setNeedsDisplay];
        
        UIImage *image = [self spotLightImage:self.image];
        [self.sharedImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    }
    else if (index == 2)
    {
        _blurType = kCLBlurTypeCircle;
        [_sharedImageView addSubview:_circleView];
        [_circleView setNeedsDisplay];
        
        UIImage *image = [self buildResultImage:self.image withBlurImage:_blurImage];
        [self.sharedImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    }
    else if (index == 3)
    {
        _blurType = kCLBlurTypeBand;
        [_sharedImageView addSubview:_bandView];
        [_bandView setNeedsDisplay];
        
        UIImage *image = [self buildResultImage:self.image withBlurImage:_blurImage];
        [self.sharedImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    }
    else
    {
        _blurType = kCLBlurTypeNormal;
        
        // Original picture
        _sharedImageView.image = self.image;
    }
}

#pragma mark - Text Edit
- (void)initTextEditTip
{
    // Image Label
    MarqueeLabel *label = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         self.view.bounds.size.width,
                                                                         20)];
    label.text = D_LocalizedCardString(@"effect_tips");
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    label.marqueeType = MLContinuous;
    label.scrollDuration = 10.0f;
    label.fadeLength = 0.0f;
    label.rate = 30.0f;
    
    label.layer.cornerRadius = 5;
    label.layer.borderColor = [UIColor grayColor].CGColor;
    label.layer.borderWidth = 1;
    [self.view addSubview:label];
}

#pragma mark - View LifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IOS7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom;
    }
    
    self.recordResourceId = -100;
    [self initNavgationBar];
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
}

- (void)initResource
{
    self.view.backgroundColor = [UIColor whiteColor];
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - iOS7AddStatusHeight)];
    [self.view addSubview:_contentView];
    
    CGRect rect = CGRectZero;
    rect.origin.x = 0;
    rect.origin.y = 0;
    UIImage *image = self.image;
    CGFloat height = image.size.height;
    CGFloat width = image.size.width;
    if (width > _contentView.frame.size.width)
    {
        rect.size.width = _contentView.frame.size.width;
        rect.size.height = height*(_contentView.frame.size.width /width);
    }
    else
    {
        rect.size.width = width;
        rect.size.height = height;
    }
    
    rect.origin.x = (_contentView.frame.size.width - rect.size.width)/2.0f;
    if (rect.size.height < self.contentView.frame.size.height)
    {
        rect.origin.y = (_contentView.frame.size.height - rect.size.height)/2.0f;
    }
    
    _sharedImageView = [[UIImageView alloc] initWithFrame:rect];
    _sharedImageView.image = image;
    _sharedImageView.clipsToBounds = TRUE;
    [_contentView addSubview:_sharedImageView];
    _contentView.contentSize = CGSizeMake(_contentView.frame.size.width, rect.size.height);
    
    [self initBannerMenu];
    [self initBlur];
    [self initTextEditTip];
}

- (void)initNavgationBar
{
    self.title = D_LocalizedCardString(@"nav_title_preview");
    NSString *fontName = D_LocalizedCardString(@"FontName");
    CGFloat fontSize = 18;
    
    UIButton *saveButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    [saveButton setTitle:D_LocalizedCardString(@"Export") forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont fontWithName:fontName size:fontSize]];
    [saveButton addTarget:self
                      action:@selector(showCustomActionSheet:withEvent:)
            forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    UIButton *backButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    [backButton setTitle:D_LocalizedCardString(@"Button_Back") forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont fontWithName:fontName size:fontSize]];
    [backButton addTarget:self
                   action:@selector(backButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Blur
- (void)initBlur
{
    _blurType = kCLBlurTypeNormal;
    _blurImage = [self.image gaussBlur:1.0];
    
    _X = 0.5;
    _Y = 0.5;
    _R = 0.5;
    
    [self setHandlerView];
    [self setDefaultParams];
}

- (void)setHandlerView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandlerView:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandlerView:)];
    UIPinchGestureRecognizer *pinch    = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandlerView:)];
    UIRotationGestureRecognizer *rotate   = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateHandlerView:)];
    
    panGesture.maximumNumberOfTouches = 1;
    
    tapGesture.delegate = self;
    panGesture.delegate = self;
    pinch.delegate = self;
    rotate.delegate = self;
    
    [_contentView addGestureRecognizer:tapGesture];
    [_contentView addGestureRecognizer:panGesture];
    [_contentView addGestureRecognizer:pinch];
    [_contentView addGestureRecognizer:rotate];
}

- (void)setDefaultParams
{
    CGFloat W = 1.5*MIN(_contentView.width, _contentView.height);
    _circleView = [[CLBlurCircle alloc] initWithFrame:CGRectMake(_contentView.width/2-W/2, _contentView.height/2-W/2, W, W)];
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.color = [UIColor redColor];
    
    CGFloat H = _contentView.height;
    CGFloat R = sqrt((_contentView.width*_contentView.width) + (_contentView.height*_contentView.height));
    _bandView = [[CLBlurBand alloc] initWithFrame:CGRectMake(0, 0, R, H)];
    _bandView.center = CGPointMake(_contentView.width/2, _contentView.height/2);
    _bandView.backgroundColor = [UIColor clearColor];
    _bandView.color = [UIColor redColor];
    
    CGFloat ratio = self.image.size.width / _contentView.width;
    _bandImageRect = _bandView.frame;
    _bandImageRect.size.width  *= ratio;
    _bandImageRect.size.height *= ratio;
    _bandImageRect.origin.x *= ratio;
    _bandImageRect.origin.y *= ratio;
    
    _spotLightView = [[CLSpotCircle alloc] initWithFrame:CGRectMake(_contentView.width/2-W/2, _contentView.height/2-W/2, W, W)];
    _spotLightView.backgroundColor = [UIColor clearColor];
    _spotLightView.color = [UIColor redColor];
}

- (void)buildThumnailImage
{
    static BOOL inProgress = NO;
    if(inProgress)
    {
        return;
    }
    
    inProgress = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (_blurType == KCLSpotLight)
        {
            UIImage *image = [self spotLightImage:self.image];
            [self.sharedImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        }
        else
        {
            UIImage *image = [self buildResultImage:self.image withBlurImage:_blurImage];
            [self.sharedImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        }
        
        [_sharedImageView setNeedsDisplay];
        inProgress = NO;
    });
}

- (UIImage*)buildResultImage:(UIImage*)image withBlurImage:(UIImage*)blurImage
{
    UIImage *result = blurImage;
    switch (_blurType)
    {
        case kCLBlurTypeCircle:
        {
            result = [self circleBlurImage:image withBlurImage:blurImage];
            break;
        }
        case kCLBlurTypeBand:
        {
            result = [self bandBlurImage:image withBlurImage:blurImage];
            break;
        }
        case KCLSpotLight:
        {
            result = [self spotLightImage:image];
            break;
        }
        default:
            break;
    }
    return result;
}

- (UIImage *)glassBlurOnImage: (UIImage *)imageToBlur
                   withRadius:(CGFloat)blurRadius
{
    if ((blurRadius <= 0.0f) || (blurRadius > 1.0f))
    {
        blurRadius = 0.5f;
    }
    
    int boxSize = (int)(blurRadius * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef rawImage = imageToBlur.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(rawImage);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(rawImage);
    inBuffer.height = CGImageGetHeight(rawImage);
    inBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(rawImage) * CGImageGetHeight(rawImage));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(rawImage);
    outBuffer.height = CGImageGetHeight(rawImage);
    outBuffer.rowBytes = CGImageGetBytesPerRow(rawImage);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    if (error)
    {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(imageToBlur.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    // Clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (UIImage*)spotLightEffect:(UIImage*)image
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    
    CGFloat R = MIN(image.size.width, image.size.height) * 0.5 * (_R + 0.1);
    CIVector *vct = [[CIVector alloc] initWithX:image.size.width * _X Y:image.size.height * (1 - _Y)];
    [filter setValue:vct forKey:@"inputCenter"];
    [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    NSLog(@"SpotEffect radius: %f, center.x: %f, center.y: %f", R, image.size.width * _X, image.size.height * (1 - _Y));
    
    return result;
}

- (UIImage*)spotLightImage:(UIImage*)image
{
    CGFloat ratio = image.size.width / _contentView.width;
    CGRect frame  = _spotLightView.frame;
    frame.size.width  *= ratio;
    frame.size.height *= ratio;
    frame.origin.x *= ratio;
    frame.origin.y *= ratio;
    
    UIImage *mask = [UIImage imageNamed:@"circle_white"];
    UIGraphicsBeginImageContext(image.size);
    {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor whiteColor] CGColor]);
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height));
        [mask drawInRect:frame];
        mask = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    UIImage *tmp = [image maskedImage:mask];
    UIGraphicsBeginImageContext(image.size);
    {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor blackColor] CGColor]);
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height));
        [tmp drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        tmp = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return tmp;
}

- (UIImage*)blurImage:(UIImage*)image withBlurImage:(UIImage*)blurImage andMask:(UIImage*)maskImage
{
    UIImage *tmp = [image maskedImage:maskImage];
    UIGraphicsBeginImageContext(image.size);
    {
        [blurImage drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        [tmp drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        tmp = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return tmp;
}

- (UIImage*)circleBlurImage:(UIImage*)image withBlurImage:(UIImage*)blurImage
{
    CGFloat ratio = image.size.width / _contentView.width;
    CGRect frame  = _circleView.frame;
    frame.size.width  *= ratio;
    frame.size.height *= ratio;
    frame.origin.x *= ratio;
    frame.origin.y *= ratio;
    
    UIImage *mask = [UIImage imageNamed:@"circle_black"];
    UIGraphicsBeginImageContext(image.size);
    {
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor whiteColor] CGColor]);
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height));
        [mask drawInRect:frame];
        mask = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [self blurImage:image withBlurImage:blurImage andMask:mask];
}

- (UIImage*)bandBlurImage:(UIImage*)image withBlurImage:(UIImage*)blurImage
{
    UIImage *mask = [UIImage imageNamed:@"band_black"];
    UIGraphicsBeginImageContext(image.size);
    {
        CGContextRef context =  UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
        
        CGContextSaveGState(context);
        CGFloat ratio = image.size.width / self.image.size.width;
        CGFloat Tx = (_bandImageRect.size.width/2  + _bandImageRect.origin.x)*ratio;
        CGFloat Ty = (_bandImageRect.size.height/2 + _bandImageRect.origin.y)*ratio;
        
        CGContextTranslateCTM(context, Tx, Ty);
        CGContextRotateCTM(context, _bandView.rotation);
        CGContextTranslateCTM(context, 0, _bandView.offset*image.size.width/_contentView.width);
        CGContextScaleCTM(context, 1, _bandView.scale);
        CGContextTranslateCTM(context, -Tx, -Ty);
        
        CGRect rct = _bandImageRect;
        rct.size.width  *= ratio;
        rct.size.height *= ratio;
        rct.origin.x    *= ratio;
        rct.origin.y    *= ratio;
        
        [mask drawInRect:rct];
        
        CGContextRestoreGState(context);
        
        mask = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return [self blurImage:image withBlurImage:blurImage andMask:mask];
}

#pragma mark- Gesture handler
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)tapHandlerView:(UITapGestureRecognizer*)sender
{
    switch (_blurType)
    {
        case kCLBlurTypeCircle:
        {
            CGPoint point = [sender locationInView:_contentView];
            _circleView.center = point;
            [self buildThumnailImage];
            
            break;
        }
        case kCLBlurTypeBand:
        {
            CGPoint point = [sender locationInView:_contentView];
            point = CGPointMake(point.x-_contentView.width/2, point.y-_contentView.height/2);
            point = CGPointMake(point.x*cos(-_bandView.rotation)-point.y*sin(-_bandView.rotation), point.x*sin(-_bandView.rotation)+point.y*cos(-_bandView.rotation));
            _bandView.offset = point.y;
            [self buildThumnailImage];
            
            break;
        }
        case KCLSpotLight:
        {
            CGPoint point = [sender locationInView:_contentView];
            _spotLightView.center = point;
           [self buildThumnailImage];
            
            break;
        }
        default:
            break;
    }
}

- (void)panHandlerView:(UIPanGestureRecognizer*)sender
{
    switch (_blurType)
    {
        case kCLBlurTypeCircle:
        {
            CGPoint point = [sender locationInView:_contentView];
            _circleView.center = point;
            [self buildThumnailImage];
            
            break;
        }
        case kCLBlurTypeBand:
        {
            CGPoint point = [sender locationInView:_contentView];
            point = CGPointMake(point.x-_contentView.width/2, point.y-_contentView.height/2);
            point = CGPointMake(point.x*cos(-_bandView.rotation)-point.y*sin(-_bandView.rotation), point.x*sin(-_bandView.rotation)+point.y*cos(-_bandView.rotation));
            _bandView.offset = point.y;
            [self buildThumnailImage];
            
            break;
        }
        case KCLSpotLight:
        {
            CGPoint point = [sender locationInView:_contentView];
            _spotLightView.center = point;
            [self buildThumnailImage];
            
            break;
        }
        default:
            break;
    }
}

- (void)pinchHandlerView:(UIPinchGestureRecognizer*)sender
{
    switch (_blurType)
    {
        case kCLBlurTypeCircle:
        {
            static CGRect initialFrame;
            if (sender.state == UIGestureRecognizerStateBegan)
            {
                initialFrame = _circleView.frame;
            }
            
            CGFloat scale = sender.scale;
            CGRect rct;
            rct.size.width  = MAX(MIN(initialFrame.size.width*scale, 3*MAX(_contentView.width, _contentView.height)), 0.3*MIN(_contentView.width, _contentView.height));
            rct.size.height = rct.size.width;
            rct.origin.x = initialFrame.origin.x + (initialFrame.size.width-rct.size.width)/2;
            rct.origin.y = initialFrame.origin.y + (initialFrame.size.height-rct.size.height)/2;
            
            _circleView.frame = rct;
            [self buildThumnailImage];
            
            break;
        }
        case kCLBlurTypeBand:
        {
            static CGFloat initialScale;
            if (sender.state == UIGestureRecognizerStateBegan)
            {
                initialScale = _bandView.scale;
            }
            
            _bandView.scale = MIN(2, MAX(0.2, initialScale * sender.scale));
            [self buildThumnailImage];
            
            break;
        }
        case KCLSpotLight:
        {
            static CGRect initialFrame;
            if (sender.state == UIGestureRecognizerStateBegan)
            {
                initialFrame = _spotLightView.frame;
            }
            
            CGFloat scale = sender.scale;
            CGRect rct;
            rct.size.width  = MAX(MIN(initialFrame.size.width*scale, 3*MAX(_contentView.width, _contentView.height)), 0.3*MIN(_contentView.width, _contentView.height));
            rct.size.height = rct.size.width;
            rct.origin.x = initialFrame.origin.x + (initialFrame.size.width-rct.size.width)/2;
            rct.origin.y = initialFrame.origin.y + (initialFrame.size.height-rct.size.height)/2;
            _spotLightView.frame = rct;
            
            [self buildThumnailImage];
            
            break;
        }
        default:
            break;
    }
}

- (void)rotateHandlerView:(UIRotationGestureRecognizer*)sender
{
    switch (_blurType)
    {
        case kCLBlurTypeBand:
        {
            static CGFloat initialRotation;
            if (sender.state == UIGestureRecognizerStateBegan)
            {
                initialRotation = _bandView.rotation;
            }
            
            _bandView.rotation = MIN(M_PI/2, MAX(-M_PI/2, initialRotation + sender.rotation));
            [self buildThumnailImage];
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - Custom ActionSheet
- (void)showCustomActionSheet:(UIBarButtonItem *)barButtonItem withEvent:(UIEvent *)event
{
    UIView *anchor = [event.allTouches.anyObject view];
    
    JGActionSheetSection *sectionExport = [JGActionSheetSection sectionWithTitle:D_LocalizedCardString(@"Export") message:nil buttonTitles:@[D_LocalizedCardString(@"Save")] buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *sectionShare = [JGActionSheetSection sectionWithTitle:D_LocalizedCardString(@"AppContent") message:nil buttonTitles:@[
                       D_LocalizedCardString(@"ShareWechat"),
                       D_LocalizedCardString(@"ShareTwitter"),
                       D_LocalizedCardString(@"ShareFacebook"),
                       D_LocalizedCardString(@"ShareOthers")] buttonStyle:JGActionSheetButtonStyleDefault];
    
    NSArray *sections = (iPad ? @[sectionExport, sectionShare] : @[sectionExport, sectionShare, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[D_LocalizedCardString(@"card_meitu_cancel")] buttonStyle:JGActionSheetButtonStyleCancel]]);
    JGActionSheet *sheet = [[JGActionSheet alloc] initWithSections:sections];
//    sheet.insets = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath)
     {
         NSLog(@"indexPath: %ld; section: %ld", (long)indexPath.row, (long)indexPath.section);
         
         if (indexPath.section == 0)
         {
             if (indexPath.row == 0)
             {
                 // Save
                 [self saveTapHandler];
             }
         }
         else if (indexPath.section == 1)
         {
             // Share
//             if (indexPath.row == 0)
//             {
//                 [self sharePhotoBySinaWeibo];
//             }
             if (indexPath.row == 0)
             {
                 [self sharePhotoByWechat];
             }
             else if (indexPath.row == 1)
             {
                 if (![self sharePhotoByTwitter])
                 {
                     [self popAlert:D_LocalizedCardString(@"TWitterInvalidContent") andTitle:D_LocalizedCardString(@"TwitterInvalidTitle")];
                 };
             }
             else if (indexPath.row == 2)
             {
                 if (![self sharePhotoByFacebook])
                 {
                     [self popAlert:D_LocalizedCardString(@"FacebookInvalidContent") andTitle:D_LocalizedCardString(@"FacebookInvalidTitle")];
                 };
             }
             else if (indexPath.row == 3)
             {
                [self sharePhotoByOthers];
             }
         }
         
         [sheet dismissAnimated:YES];
     }];
    
    if (iPad)
    {
        [sheet setOutsidePressBlock:^(JGActionSheet *sheet)
         {
             [sheet dismissAnimated:YES];
         }];
        
        CGPoint point = (CGPoint){ CGRectGetMidX(anchor.bounds), CGRectGetMaxY(anchor.bounds) };
        point = [self.navigationController.view convertPoint:point fromView:anchor];
        
        [sheet showFromPoint:point inView:self.navigationController.view arrowDirection:JGActionSheetArrowDirectionTop animated:YES];
    }
    else
    {
        [sheet setOutsidePressBlock:^(JGActionSheet *sheet)
         {
             [sheet dismissAnimated:YES];
         }];
        
        [sheet showInView:self.navigationController.view animated:YES];
    }
}

#pragma mark - Save
- (void)saveTapHandler
{
    [[LoadingViewManager sharedInstance] showText:D_LocalizedCardString(@"Video_Processing") inView:self.view];
    if (_blurType != kCLBlurTypeNormal)
    {
        UIImage *image = [self buildResultImage:self.image withBlurImage:_blurImage];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
    }
    else
    {
      UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), nil);
    }
}


#pragma mark - savePhotoAlbumDelegate
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
    NSString *message;
    NSString *title;
    if (!error)
    {
        title = D_LocalizedCardString(@"Success");
        message = D_LocalizedCardString(@"SaveSuccess");
    }
    else
    {
        title = D_LocalizedCardString(@"Failed");
        message = [error description];
    }
    
    [[LoadingViewManager sharedInstance] removeLoadingView:self.view];
    [[LoadingViewManager sharedInstance] showHUDWithText:message inView:self.view duration:0.5f];
    
}

- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end