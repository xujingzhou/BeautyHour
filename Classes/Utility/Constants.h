//  Constants.h
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//

#define kShadowColor1		[UIColor blackColor]
#define kShadowColor2		[UIColor colorWithWhite:0.0 alpha:0.75]
#define kShadowOffset		CGSizeMake(0.0, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4.0 : 2.0)
#define kShadowBlur			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 10.0 : 5.0)
#define kInnerShadowOffset	CGSizeMake(0.0, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 2.0 : 1.0)
#define kInnerShadowBlur	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4.0 : 2.0)

#define kStrokeColor		[UIColor blackColor]
#define kStrokeSize			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 6.0 : 3.0)

#define kGradientStartColor	[UIColor colorWithRed:255.0 / 255.0 green:193.0 / 255.0 blue:127.0 / 255.0 alpha:1.0]
#define kGradientEndColor	[UIColor colorWithRed:255.0 / 255.0 green:163.0 / 255.0 blue:64.0 / 255.0 alpha:1.0]


// Google Ads
#define kGoogleBannerAdUnitID @"ca-app-pub-4954715608308009/5376844570"
#define kGoogleInterstitialAdUnitID @"ca-app-pub-4954715608308009/6853577774"

// Wechat
#define kWechatAppID @"wx7959265fd6dfa306"
#define kWechatSecretID @"92e551eea17e86a15fb0455630dcce2d"

// Sina Weibo
#define kAppWeiboAppID         @"519869435"
#define kAppWeiboSecretID      @"5ad8bd6d47aeedb8b9c398a0692be7b4"
#define kWeiboRedirectURI    @"http://www.sina.com"


// ShareSDK
#define kShareSDKAppID @"44eaad665402"
#define kShareSDKSecretID @"9f3e43a2cfb3795adaf17a93b50ee9e1"

// Facebook
#define kFacebookAppID @"301850866674289"
#define kFacebookSecretID @"b5cedf99e0453091cbf8df92cc1e0fce"

// Color
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kNavigationBarBottomSeperatorColor RGBCOLOR(255, 207, 51)
#define kTableViewSeperatorColor RGBCOLOR(75, 72, 72)
#define kBackgroundColor RGBCOLOR(40, 39, 37)
#define kTableViewCellTitleColor RGBCOLOR(172, 171, 169)
#define kTextGrayColor RGBCOLOR(148, 147, 146)
#define kLightBlue [UIColor colorWithRed:155/255.0f green:188/255.0f blue:220/255.0f alpha:1]
#define kBrightBlue [UIColor colorWithRed:100/255.0f green:100/255.0f blue:230/255.0f alpha:1]


#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define iOS6 ((([[UIDevice currentDevice].systemVersion intValue] >= 6) && ([[UIDevice currentDevice].systemVersion intValue] < 7)) ? YES : NO )
#define iOS5 ((([[UIDevice currentDevice].systemVersion intValue] >= 5) && ([[UIDevice currentDevice].systemVersion intValue] < 6)) ? YES : NO )

#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

#define kWinSize [UIScreen mainScreen].bounds.size
#define iOS7AddStatusHeight     (IOS7?20:0)
#define D_LocalizedCardString(s) [[NSBundle mainBundle] localizedStringForKey:s value:nil table:@"CardToolLanguage"]
#define D_Main_Appdelegate (AppDelegate *)[UIApplication sharedApplication].delegate

/* { thread } */
#define __async_opt__  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define __async_main__ dispatch_async(dispatch_get_main_queue()

#define foo4random() (1.0 * (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX)
#define DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

static const CGFloat kCLEffectToolAnimationDuration = 0.3;

#pragma mark - Random Color
static inline UIColor *GetRandomUIColor()
{
    CGFloat r = arc4random() % 255;
    CGFloat g = arc4random() % 255;
    CGFloat b = arc4random() % 255;
    UIColor * color = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1.0f];
    return color;
}

#pragma mark - String
static inline BOOL isStringEmpty(NSString *value)
{
    BOOL result = FALSE;
    if (!value || [value isKindOfClass:[NSNull class]])
    {
        // null object
        result = TRUE;
    }
    else
    {
        NSString *trimedString = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([value isKindOfClass:[NSString class]] && [trimedString length] == 0)
        {
            // empty string
            result = TRUE;
        }
    }
    
    return result;
}

#pragma mark - App Info
static inline NSString* getAppVersion()
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    NSLog(@"App version: %@", versionNum);
    return versionNum;
}

static inline NSString* getAppName()
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDict objectForKey:@"CFBundleDisplayName"];
    NSLog(@"App name: %@", appName);
    return appName;
}

static inline NSString* getAppNameByInfoPlist()
{
    NSString *appName = NSLocalizedStringFromTable(@"CFBundleDisplayName", @"InfoPlist", nil);
    NSLog(@"App name: %@", appName);
    return appName;
}

/* 得到本机现在用的语言  * en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本 ...... */
static inline NSString* getPreferredLanguage()
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    
    NSLog(@"Preferred Language: %@", preferredLang);
    return preferredLang;
}

static inline NSString* getCurrentlyLanguage()
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    NSLog(@"currentLanguage: %@", currentLanguage);
    return currentLanguage;
}

static inline BOOL isZHHansFromCurrentlyLanguage()
{
    BOOL bResult = FALSE;
    NSString *curLauguage = getCurrentlyLanguage();
    NSString *cnLauguage = @"zh-Hans";
    if ([curLauguage compare:cnLauguage options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
    {
        bResult = TRUE;
    }
    
    return bResult;
}

#define CURR_LANG ([[NSLocale preferredLanguages] objectAtIndex: 0])
static inline NSString* DPLocalizedString(NSString *translation_key)
{
    NSString * string = NSLocalizedString(translation_key, nil );
    if (![CURR_LANG isEqual:@"en"] && ![CURR_LANG isEqualToString:@"zh-Hans"] && ![CURR_LANG isEqualToString:@"ja"])
    {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        string = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    
    return string;
}

#pragma mark - File Manager
static inline NSArray* getFilelistBySymbol(NSString *symbol, NSString *dirPath)
{
    NSMutableArray *filelist = [NSMutableArray arrayWithCapacity:1];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    for (NSString *filename in tmplist)
    {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        BOOL fileExisted = [[NSFileManager defaultManager] fileExistsAtPath:fullpath];
        if (fileExisted)
        {
            if ([[filename lastPathComponent] hasPrefix:symbol])
            {
                [filelist  addObject:filename];
            }
        }
    }
    
    return filelist;
}

static inline BOOL isFileExistAtPath(NSString *fileFullPath)
{
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

