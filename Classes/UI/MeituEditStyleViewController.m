//  MeituEditStyleViewController
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//

#import "MeituEditStyleViewController.h"
#import "AppDelegate.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"
#import "CMPopTipView.h"
#import "StickerView.h"
#import "MarqueeLabel.h"
#import "CLTextView.h"
#import "YcKeyBoardView.h"
#import "InfColorPicker.h"
#import "JGActionSheet.h"
#import "KxMenu.h"
#import "FontVC.h"

@interface MeituEditStyleViewController ()<MeituImageEditViewDelegate, CMPopTipViewDelegate, YcKeyBoardViewDelegate, UIGestureRecognizerDelegate, InfColorPickerControllerDelegate, UIPopoverControllerDelegate, JGActionSheetDelegate>
{
    CMPopTipView *_popTipView;
    
    // Color picker by iPad
    UIPopoverController* _activePopover;
}

@property (nonatomic,strong)YcKeyBoardView *keyboard;
@property (nonatomic, strong) CLTextView *selectedTextView;
@property (nonatomic, assign) BOOL isNewFont;

@property (nonatomic, strong) UIColor *color;

@end

@implementation MeituEditStyleViewController

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
    
    if ([self.assets count] == 1)
    {
        [_popTipView presentPointingAtView:_borderButton inView:self.view animated:YES];
    }
    else if ([self.assets count] > 1)
    {
        [_popTipView presentPointingAtView:_puzzleButton inView:self.view animated:YES];
    }
}

#pragma mark - Fonts Init
- (void)popoverFontVC
{
    FontVC *fontVC = [[FontVC alloc] init];
    
    // Callback
    [fontVC setFontSuccessBlock:^(BOOL success, id result)
    {
         if (success)
         {
             NSLog(@"%@", result);
             
             // Change font
             CGFloat fontSize = 35;
             self.selectedTextView.font = [UIFont fontWithName:result size:fontSize];
             [self.selectedTextView sizeToFitWithMaxWidth:0.8*self.contentView.width lineHeight:0.2*self.contentView.height];
         }
     }];
    
    [self.navigationController pushViewController:fontVC animated:YES];
}

#pragma mark - Color Picker
- (void)popoverColorPicker: (id)sender
{
    NSLog(@"popoverColorPicker Invoked.");
    
    if (iPad)
    {
        if ([self dismissActivePopover])
            return;
        
        InfColorPickerController* picker = [InfColorPickerController colorPickerViewController];
        picker.sourceColor = self.color;
        picker.delegate = self;
        
        UIPopoverController* popover = [[UIPopoverController alloc] initWithContentViewController: picker];
        [self showPopover: popover from: sender];
    }
    else
    {
        InfColorPickerController* picker = [InfColorPickerController colorPickerViewController];
        picker.sourceColor = self.color;
        picker.delegate = self;
        [picker presentModallyOverViewController: self];
    }
}

#pragma mark - InfColorPickerControllerDelegate
- (void)colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
    self.color = picker.resultColor;
    self.selectedTextView.fillColor = self.color;
    NSLog(@"colorPickerControllerDidFinish invoked.");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerControllerDidChangeColor: (InfColorPickerController*) picker
{
    if (iPad)
    {
        self.color = picker.resultColor;
        self.selectedTextView.fillColor = self.color;
    }
}

#pragma mark - UIPopoverControllerDelegate methods
- (void)popoverControllerDidDismissPopover: (UIPopoverController*) popoverController
{
    if ([popoverController.contentViewController isKindOfClass: [InfColorPickerController class]])
    {
        InfColorPickerController* picker = (InfColorPickerController*) popoverController.contentViewController;
        self.color = picker.resultColor;
        self.selectedTextView.fillColor = self.color;
    }
    
    if (popoverController == _activePopover)
    {
        _activePopover = nil;
    }
}

- (void)showPopover: (UIPopoverController*) popover from: (id) sender
{
    popover.delegate = self;
    _activePopover = popover;
    
    if ([sender isKindOfClass: [UIBarButtonItem class]])
    {
        [_activePopover presentPopoverFromBarButtonItem: sender
                              permittedArrowDirections: UIPopoverArrowDirectionAny
                                              animated: YES];
    }
    else
    {
        UIView* senderView = sender;
        [_activePopover presentPopoverFromRect: [senderView bounds]
                                       inView: senderView
                     permittedArrowDirections: UIPopoverArrowDirectionAny
                                     animated: YES];
    }
}

- (BOOL)dismissActivePopover
{
    if (_activePopover)
    {
        [_activePopover dismissPopoverAnimated: YES];
        [self popoverControllerDidDismissPopover: _activePopover];
        
        return YES;
    }
    
    return NO;
}

#pragma mark - Keyboard Custom
- (void)addNewText
{
    CGFloat fontSize = 35;
    CLTextView *view = [[CLTextView alloc] init];
    if (isZHHansFromCurrentlyLanguage())
    {
        int random = arc4random() % ((unsigned)2);
        if (random == 0)
        {
            // 徐静蕾字体
            NSString *fontName = @"yolan-yolan";
            view.font = [UIFont fontWithName:fontName size:fontSize];
            NSLog(@"FontWithName: 徐静蕾字体");
        }
        else
        {
            // 少女幼圆字体
            NSString *fontName = @"FrLt DFGirl";
            view.font = [UIFont fontWithName:fontName size:fontSize];
            NSLog(@"FontWithName: 少女幼圆字体");
        }
    }
    else
    {
        int random = arc4random() % ((unsigned)5);
        if (random == 0)
        {
            NSString *fontName = @"Team Captain";
            view.font = [UIFont fontWithName:fontName size:fontSize];
            NSLog(@"FontWithName: AcademyEngravedLetPlain");
        }
        else if (random == 1)
        {
            NSString *fontName = @"SketchyComic";
            view.font = [UIFont fontWithName:fontName size:fontSize];
            NSLog(@"FontWithName: Noteworthy-Bold");
        }
        else if (random == 2)
        {
            // 少女幼圆字体
            NSString *fontName = @"FrLt DFGirl";
            view.font = [UIFont fontWithName:fontName size:fontSize];
            NSLog(@"FontWithName: 少女幼圆字体");
        }
        else if (random == 3)
        {
            // 徐静蕾字体
            NSString *fontName = @"yolan-yolan";
            view.font = [UIFont fontWithName:fontName size:fontSize];
            NSLog(@"FontWithName: 徐静蕾字体");
        }
        else
        {
            NSLog(@"FontWithName: Default font");
        }
    }
    
    CGFloat ratio = MIN( (0.8 * self.contentView.width) / view.width, (0.2 * self.contentView.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(self.contentView.width/2, 80);
    
    NSLog(@"New text: x = %f, y = %f, width = %f, height = %f", view.frame.origin.x, view.frame.origin.y, view.bounds.size.width, view.bounds.size.height);
    
    [self.contentView addSubview:view];
    [CLTextView setActiveTextView:view];
}

- (void)setSelectedTextView:(CLTextView *)selectedTextView
{
    if(selectedTextView != _selectedTextView)
    {
        _selectedTextView = selectedTextView;
        
        NSLog(@"setSelectedTextView invoked.");
    }
}

- (void)activeTextViewDidChange:(NSNotification*)notification
{
    self.selectedTextView = notification.object;
}

- (void)activeTextViewDidTap:(NSNotification*)notification
{
    NSLog(@"Single tap invoked.");
    
    self.isNewFont = FALSE;
    
    // Start text edit
    [self initKeyboard];
}

- (void)activeTextViewDidDoubleTap:(NSNotification*)notification
{
    NSLog(@"Double tap invoked.");
    
    self.isNewFont = FALSE;
    // Show custom actionsheet
    [self showCustomActionSheet:notification.object];
}

#pragma mark - CustomMenu
- (void)popoverMenu:(UIView *)anchor
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:D_LocalizedCardString(@"ChangePattern")
                     image:nil
                    target:nil
                    action:NULL],
      
      [KxMenuItem menuItem:D_LocalizedCardString(@"FontStyleDefault")
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:D_LocalizedCardString(@"FontStyleShadow")
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:D_LocalizedCardString(@"FontStyleEmboss")
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:D_LocalizedCardString(@"FontStyleGradientFill")
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:D_LocalizedCardString(@"FontStyleRainbow")
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      
      [KxMenuItem menuItem:D_LocalizedCardString(@"FontStyleSynthesis")
                     image:nil
                    target:self
                    action:@selector(pushMenuItem:)],
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = kBrightBlue; //[UIColor colorWithRed:59./255. green:89./255. blue:152./255. alpha:0.6f];
    
    [KxMenu showMenuInView:self.view
                  fromRect:anchor.frame
                 menuItems:menuItems];
}

- (void)pushMenuItem:(id)sender
{
    if ([sender isKindOfClass:[KxMenuItem class]])
    {
        NSLog(@"pushMenuItem: %@", sender);
        
        KxMenuItem *menuItem = sender;
        if ([menuItem.title compare:D_LocalizedCardString(@"FontStyleShadow") options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
        {
            self.selectedTextView.labelStyle = kShadow;
        }
        else if ([menuItem.title compare:D_LocalizedCardString(@"FontStyleEmboss") options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
        {
            self.selectedTextView.labelStyle = kInnerShadow;
        }
        else if ([menuItem.title compare:D_LocalizedCardString(@"FontStyleGradientFill") options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
        {
            self.selectedTextView.labelStyle = kGradientFill;
        }
        else if ([menuItem.title compare:D_LocalizedCardString(@"FontStyleRainbow") options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
        {
            self.selectedTextView.labelStyle = kMultiPartGradient;
        }
        else if ([menuItem.title compare:D_LocalizedCardString(@"FontStyleSynthesis") options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame)
        {
            self.selectedTextView.labelStyle = kSynthesis;
        }
        else
        {
            self.selectedTextView.labelStyle = kDefault;
        }
        
        [self.selectedTextView sizeToFitWithMaxWidth:0.8*self.contentView.width lineHeight:0.2*self.contentView.height];
    }
}


#pragma mark - Custom ActionSheet
- (void)showCustomActionSheet:(UIView *)anchor
{
    JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:D_LocalizedCardString(@"ChangeStyle") message:D_LocalizedCardString(@"ChangeDescription") buttonTitles:@[D_LocalizedCardString(@"Font"), D_LocalizedCardString(@"Color"), D_LocalizedCardString(@"Pattern")] buttonStyle:JGActionSheetButtonStyleDefault];
    [section setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:0];
    [section setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:1];
    [section setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:2];
    
    NSArray *sections = (iPad ? @[section] : @[section, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[D_LocalizedCardString(@"card_meitu_cancel")] buttonStyle:JGActionSheetButtonStyleCancel]]);
    JGActionSheet *sheet = [[JGActionSheet alloc] initWithSections:sections];
    sheet.delegate = self;
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath)
     {
         NSLog(@"indexPath: %ld; section: %ld", (long)indexPath.row, (long)indexPath.section);
         
         if (indexPath.section == 0)
         {
             if (indexPath.row == 0)
             {
                 // Change font
                 [self popoverFontVC];
             }
             else if(indexPath.row == 1)
             {
                 // Change font color
                 [self popoverColorPicker:anchor];
             }
             else if(indexPath.row == 2)
             {
                 // Change pattern
                 [self popoverMenu:anchor];
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

#pragma mark - JGActionSheetDelegate
- (void)actionSheetWillPresent:(JGActionSheet *)actionSheet
{
    NSLog(@"Action sheet %p will present", actionSheet);
}

- (void)actionSheetDidPresent:(JGActionSheet *)actionSheet
{
    NSLog(@"Action sheet %p did present", actionSheet);
}

- (void)actionSheetWillDismiss:(JGActionSheet *)actionSheet
{
    NSLog(@"Action sheet %p will dismiss", actionSheet);
}

- (void)actionSheetDidDismiss:(JGActionSheet *)actionSheet
{
    NSLog(@"Action sheet %p did dismiss", actionSheet);
}

#pragma mark - Notify
- (void)removeNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initNotify
{
    // Keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Text edit notify
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidChange:) name:CLTextViewActiveViewDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidTap:) name:CLTextViewActiveViewDidTapNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeTextViewDidDoubleTap:) name:CLTextViewActiveViewDidDoubleTapNotification object:nil];
}

#pragma mark - Keyboard
- (void)initKeyboard
{
    int texViewtHeight = 44;
    if(self.keyboard == nil)
    {
        self.keyboard = [[YcKeyBoardView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - texViewtHeight, self.view.bounds.size.width, texViewtHeight)];
    }
    self.keyboard.delegate = self;
    [self.keyboard.textView becomeFirstResponder];
    self.keyboard.textView.returnKeyType = UIReturnKeyDefault; //UIReturnKeyDone;
    if (self.selectedTextView)
    {
        self.keyboard.textView.text = _selectedTextView.text;
    }
    [self.view addSubview:self.keyboard];
}

- (void)keyboardShow:(NSNotification *)notify
{
    CGRect keyBoardRect = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    [UIView animateWithDuration:[notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.keyboard.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}

- (void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.keyboard.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished){
        
        self.keyboard.textView.text = @"";
        [self.keyboard removeFromSuperview];
    }];
}

#pragma mark - YcKeyBoardViewDelegate
- (void)keyBoardViewHide:(YcKeyBoardView *)keyBoardView textView:(UITextView *)contentView
{
    NSLog(@"Keyboard contentView text: %@", contentView.text);
    
    if (!isStringEmpty(contentView.text))
    {
        if (self.isNewFont)
        {
            [self addNewText];
            self.isNewFont = FALSE;
        }
        
        self.selectedTextView.text = contentView.text;
        [self.selectedTextView sizeToFitWithMaxWidth:0.8*self.contentView.width lineHeight:0.2*self.contentView.height];
    }
    
    [contentView resignFirstResponder];
}

#pragma mark - Text Edit
- (void)initTextEditTip
{
    // Tap Image Label
    MarqueeLabel *label = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               self.view.bounds.size.width,
                                                               20)];
    label.text = D_LocalizedCardString(@"input_message_tips");
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; //kNavigationBarBottomSeperatorColor;
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    label.marqueeType = MLContinuous;
    label.scrollDuration = 10.0f;
    label.fadeLength = 0.0f;
    label.rate = 30.0f;
    
    label.layer.cornerRadius = 5;
    label.layer.borderColor = [UIColor grayColor].CGColor;
    label.layer.borderWidth = 1;
    
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pauseTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [label addGestureRecognizer:tapRecognizer];
    [self.view addSubview:label];
}

- (void)pauseTap:(UITapGestureRecognizer *)recognizer
{
    MarqueeLabel *continuousLabel = (MarqueeLabel *)recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (!continuousLabel.isPaused)
        {
            [continuousLabel pauseLabel];
        }
        else
        {
            [continuousLabel unpauseLabel];
        }
    }
}

#pragma mark - Gesture
- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            // Text edit keyboard
            [self initKeyboard];
            self.isNewFont = TRUE;
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            break;
        }
        default:
            break;
    }
}

//- (void)textEditDrag:(UIGestureRecognizer*)gestureRecognizer
//{
//    CGPoint translation = [gestureRecognizer locationInView:self.contentView];
//    _textEdit.center = CGPointMake(translation.x,  translation.y);
//}

#pragma mark - View LifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self removeNotify];
    _popTipView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = self.view.frame;
    self.view.backgroundColor = [UIColor grayColor];
    
    // Do any additional setup after loading the view.
    if (IOS7)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom;
    }
    
    self.selectStoryBoardStyleIndex = 1;
    _isFirst = YES;
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CATransition * animation = [CATransition animation];
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    animation.duration = 0.45;
    animation.removedOnCompletion = YES;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    if (_isFirst)
    {
        [self showWaitView];
        
        [self contentResetSizeWithCalc:YES];
        [self initData];
        _isFirst = NO;
        
        // Popup default scroll view
        if ([self.assets count] == 1)
        {
            [_borderButton setSelected:YES];
            _selectControlButton = _borderButton;
            
            [self bottomViewControlAction:_borderButton];
        }
        else if ([self.assets count] > 1)
        {
            [_puzzleButton setSelected:YES];
            _selectControlButton = _puzzleButton;
            
            [self bottomViewControlAction:_puzzleButton];
        }
    }
    
    [D_Main_Appdelegate hiddenPreView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    CATransition * animation = [CATransition animation];
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    animation.duration = 0.45;
    animation.removedOnCompletion = YES;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
}

- (void)initData
{
    [self resetViewByStyleIndex:1 imageCount:[self.assetsImage count]];
}

- (void)initNavgationBar
{
    self.title = D_LocalizedCardString(@"PhotoEffects");
    NSString *fontName = D_LocalizedCardString(@"FontName");
    CGFloat fontSize = 18;
    
    self.navigationItem.backBarButtonItem = nil;
    UIButton *backButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    [backButton setTitle:D_LocalizedCardString(@"Button_Back") forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont fontWithName:fontName size:fontSize]];
    [backButton addTarget:self
                   action:@selector(backButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIButton *preViewButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [preViewButton setTitle:D_LocalizedCardString(@"nav_title_preview") forState:UIControlStateNormal];
    [preViewButton.titleLabel setFont:[UIFont fontWithName:fontName size:fontSize]];
    [preViewButton addTarget:self
                      action:@selector(preViewBtnAction:)
            forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *preViewItem = [[UIBarButtonItem alloc] initWithCustomView:preViewButton];
    self.navigationItem.rightBarButtonItem = preViewItem;
}

- (void)initResource
{
    self.contentView =  [[UIScrollView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - [self calcContentSize].width)/2.0f, (self.view.frame.size.height - 2*44 - iOS7AddStatusHeight - [self calcContentSize].height)/2.0f, [self calcContentSize].width, [self calcContentSize].height)];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_contentView];
    
    self.freeBgView = [[UIImageView alloc] initWithFrame:_contentView.bounds];
    [_freeBgView setBackgroundColor:[UIColor whiteColor]];
    [_contentView addSubview:_freeBgView];
    
    // Border
    self.bringPosterView = [[UIImageView alloc] initWithFrame:_contentView.bounds];
    [_bringPosterView setBackgroundColor:[UIColor clearColor]];
    [_contentView addSubview:_bringPosterView];
    
    // LongPress Gesture
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(longPressGestureRecognized:)];
    gesture.minimumPressDuration = 0.8;
    [_contentView addGestureRecognizer:gesture];
    [_contentView setUserInteractionEnabled:YES];
    
    // Tap Gesture
//    UITapGestureRecognizer *tapTextEdit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textEditTapped)];
//    tapTextEdit.delegate = self;
//    [_contentView addGestureRecognizer:tapTextEdit];
//    [_contentView setUserInteractionEnabled:YES];
    
    // Drag Gesture
//    UIPanGestureRecognizer *dragTextEdit = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(textEditDrag:)];
//    [_contentView addGestureRecognizer:dragTextEdit];
    
    [self initBoardAndEditView];
    [self initToolbarView];
    [self initPopView];
    
    self.isNewFont = TRUE;
    self.selectedTextView = nil;
    self.color = kGradientStartColor;
    
    [self initTextEditTip];
    [self initNotify];
}

#pragma mark 
#pragma mark Bottom ToolBar

- (void)initBoardAndEditView
{
    self.boardAndEditView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44- iOS7AddStatusHeight - 33- 25 - 30, self.view.frame.size.width, 30)];
    [self.boardAndEditView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.boardAndEditView];
    
    self.editbutton  = [[UIButton alloc] initWithFrame:CGRectMake((_boardAndEditView.frame.size.width - 75)/2.0f, 0, 75, 30)];
    [self.editbutton setBackgroundImage:[UIImage imageNamed:@"btn_meitu_edit_normal"] forState:UIControlStateNormal];
    [self.editbutton setBackgroundImage:[UIImage imageNamed:@"btn_meitu_edit_highlight"] forState:UIControlStateHighlighted];
    
    [self.editbutton setTitle:D_LocalizedCardString(@"card_meitu_edit") forState:UIControlStateNormal];
    [_editbutton.layer setCornerRadius:15.0f];
    [_editbutton setClipsToBounds:YES];
    [self.boardAndEditView addSubview:_editbutton];
    
    NSString *fontName = D_LocalizedCardString(@"FontName");
    CGFloat fontSize = 14;
    [_editbutton.titleLabel setFont:[UIFont fontWithName:fontName size:fontSize]];
    [_editbutton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initToolbarView
{
    self.bottomControlView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44-iOS7AddStatusHeight - 33 - 50, self.view.frame.size.width, 50)];
    
    [self initStoryboardView];
    [self initBorderView];
    [self initStickerView];
    [self initFaceView];
    [self initFilterView];

    [self.view addSubview:_bottomControlView];
    [self.bottomControlView setContentSize:CGSizeMake(self.bottomControlView.frame.size.width *2, _bottomControlView.frame.size.height)];
    [self.bottomControlView setPagingEnabled:YES];
    [self.bottomControlView setScrollEnabled:NO];
    [_bottomControlView setHidden:YES];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44-iOS7AddStatusHeight - 33, self.view.frame.size.width, 33)];
    [_bottomView setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"NavBar-iPhone"]]];
    
    _puzzleButton = [[UIButton alloc] init];
    [_puzzleButton setTitle:D_LocalizedCardString(@"card_meitu_storyboard")
                       forState:UIControlStateNormal];
    
    _borderButton = [[UIButton alloc] init];
    [_borderButton setTitle:D_LocalizedCardString(@"card_meitu_board")
                   forState:UIControlStateNormal];
    
    _stickerButton = [[UIButton alloc] init];
    [_stickerButton setTitle:D_LocalizedCardString(@"card_essay_decoration")
                    forState:UIControlStateNormal];
    
    _faceButton = [[UIButton alloc] init];
    [_faceButton setTitle:D_LocalizedCardString(@"Face")
                    forState:UIControlStateNormal];
    
    _filterButton = [[UIButton alloc] init];
    [_filterButton setTitle:D_LocalizedCardString(@"Filter")
                   forState:UIControlStateNormal];
    
    [_puzzleButton setTag:1];
    [_borderButton setTag:2];
    [_stickerButton setTag:3];
    [_faceButton setTag:4];
    [_filterButton setTag:5];
    
    [self controlButtonStyleSettingWithButton:_puzzleButton];
    [self controlButtonStyleSettingWithButton:_borderButton];
    [self controlButtonStyleSettingWithButton:_stickerButton];
    [self controlButtonStyleSettingWithButton:_faceButton];
    [self controlButtonStyleSettingWithButton:_filterButton];
    
    [_bottomView addSubview:_puzzleButton];
    [_bottomView addSubview:_borderButton];
    [_bottomView addSubview:_stickerButton];
    [_bottomView addSubview:_faceButton];
    [_bottomView addSubview:_filterButton];
    [self.view addSubview:_bottomView];
}

- (void)controlButtonStyleSettingWithButton:(UIButton *)sender
{
    float toolbarCount = 5;
    sender.frame =  CGRectMake(_bottomView.frame.size.width/toolbarCount*(sender.tag-1), 0, _bottomView.frame.size.width/toolbarCount, _bottomView.frame.size.height);
    NSString *fontName = D_LocalizedCardString(@"FontName");
    CGFloat fontSize = 18;
    [sender.titleLabel setFont:[UIFont fontWithName:fontName size:fontSize]];

    [sender setTitleColor:kTextGrayColor forState:UIControlStateNormal];
    [sender setTitleColor:kBrightBlue forState:UIControlStateHighlighted];
    [sender setTitleColor:kBrightBlue forState:UIControlStateSelected];
    [sender addTarget:self action:@selector(bottomViewControlAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)bottomViewControlAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [_selectControlButton setSelected:NO];
    
    switch (button.tag)
    {
        case 1:
        {
            if ([self.assetsImage count] < 2)
            {
                return;
            }
            
            [self showScrollView:kPuzzleScrollView];
            [self contentResetSizeWithCalc:YES];
            
            if (_selectControlButton != _puzzleButton)
            {
                self.freeBgView.image = nil;
                self.freeBgView.backgroundColor = self.selectedBoardColor?self.selectedBoardColor:[UIColor whiteColor];
                [LoadingViewManager showLoadViewWithText:D_LocalizedCardString(@"Video_Processing") andShimmering:YES andBlurEffect:YES inView:self.view];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [self contentRemoveView];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self resetViewByStyleIndex:self.selectStoryBoardStyleIndex imageCount:self.assetsImage.count];
                        [LoadingViewManager hideLoadViewInView:self.view];
                    });
                    
                });
                
                [self.bringPosterView setHidden:NO];
            }
            
            self.bottomControlView.contentOffset = CGPointMake(0, 0);
            [self showStoryboardAndPoster];
            
            break;
        }
        case 2:
        {
            [self showScrollView:kBorderScrollView];
            [self contentResetSizeWithCalc:YES];
            
            if (_selectControlButton != _borderButton)
            {
                self.freeBgView.image = nil;
                self.freeBgView.backgroundColor = self.selectedBoardColor?self.selectedBoardColor:[UIColor whiteColor];
                [self.bringPosterView setHidden:NO];
            }
            
            self.bottomControlView.contentOffset = CGPointMake(0, 0);
            [self showStoryboardAndPoster];
            
            break;
        }
        case 3:
        {
            [self showScrollView:kStickerScrollView];
            [self contentResetSizeWithCalc:YES];
            
            if (_selectControlButton != _stickerButton)
            {
                self.freeBgView.image = nil;
                self.freeBgView.backgroundColor = self.selectedBoardColor?self.selectedBoardColor:[UIColor whiteColor];
            }
            
            self.bottomControlView.contentOffset = CGPointMake(0, 0);
            [self showStoryboardAndPoster];
            
            break;
        }
        case 4:
        {
            [self showScrollView:kFaceScrollView];
            [self contentResetSizeWithCalc:YES];
            
            if (_selectControlButton != _stickerButton)
            {
                self.freeBgView.image = nil;
                self.freeBgView.backgroundColor = self.selectedBoardColor?self.selectedBoardColor:[UIColor whiteColor];
            }
            
            self.bottomControlView.contentOffset = CGPointMake(0, 0);
            [self showStoryboardAndPoster];
            
            break;
        }
        case 5:
        {
            [self showScrollView:kFilterScrollView];
            [self contentResetSizeWithCalc:YES];
            
            if (_selectControlButton != _filterButton)
            {
                self.freeBgView.image = nil;
                self.freeBgView.backgroundColor = self.selectedBoardColor?self.selectedBoardColor:[UIColor whiteColor];
            }
            
            self.bottomControlView.contentOffset = CGPointMake(0, 0);
            [self showStoryboardAndPoster];
            
            break;
        }
        default:
            break;
    }
    
    _selectControlButton = button;
    [button setSelected:YES];

}

- (void)editButtonAction:(id)sender
{
    [D_Main_Appdelegate showPreView];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)contentResetSizeWithCalc:(BOOL)calc
{
    if (calc)
    {
        _contentView.frame = CGRectMake((self.view.frame.size.width - [self calcContentSize].width)/2.0f, (self.view.frame.size.height - 33 - [self calcContentSize].height)/2.0f, [self calcContentSize].width, [self calcContentSize].height);
        _contentView.contentSize = self.contentView.frame.size;
    }
    else
    {
        self.contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 33);
    }
}

- (CGSize)calcContentSize
{
    CGSize retSize = CGSizeZero;
    //CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 2*D_ToolbarWidth-iOS7AddStatusHeight);
    CGFloat size_width = self.view.frame.size.width;
    CGFloat size_height = size_width * 4 /3.0f;
    if (size_height >= (self.view.frame.size.height-34))
    {
        size_height = self.view.frame.size.height- 34;
        size_width = size_height * 3/4.0f;
    }
    
    retSize.width = size_width;
    retSize.height = size_height;
    return  retSize;
}

#pragma mark - Show/Hide
- (void)showStoryboardAndPoster
{
    self.bottomControlView.hidden = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.bottomControlView.frame =  CGRectMake(0, self.view.frame.size.height  - 33 - 50, self.view.frame.size.width, 50);
                         _boardAndEditView.frame =  CGRectMake(0, self.view.frame.size.height  - 33 - 50 - 30 - 10, self.view.frame.size.width, 30);
                     } completion:^(BOOL finished) {
                         
                     }];
}


- (void)hiddenStoryboardAndPoster
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.bottomControlView.frame =  CGRectMake(0, self.view.frame.size.height  - 33, self.view.frame.size.width, 1);
                         _boardAndEditView.frame =  CGRectMake(0, self.view.frame.size.height - 33- 30- 25, self.view.frame.size.width, 30);
                     } completion:^(BOOL finished) {
                         [self.bottomControlView setHidden:YES];
                     }];


}

#pragma mark
#pragma mark GLMeitoPosterSelectViewControllerDelegate

-(UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size
{
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return scaledImage;
}


- (void)didSelectedWithPoster:(NSDictionary *)posterDict
{
    if ([posterDict objectForKey:@"PosterImagePath"])
    {
        UIImage *posterImage = [UIImage imageWithContentsOfFile:[posterDict objectForKey:@"PosterImagePath"]];
        posterImage = [self originImage:posterImage scaleToSize:self.contentView.frame.size];
        self.bringPosterView.image = [posterImage stretchableImageWithLeftCapWidth:posterImage.size.width/4.0f topCapHeight:160];
        self.bringPosterView.frame = self.bringPosterView.frame;
    }
    
    NSString *boardColor = [posterDict objectForKey:@"BoardColor"];
    if (boardColor)
    {
        @try
        {
            self.freeBgView.image = nil;
            self.freeBgView.backgroundColor = [UIColor colorWithHexString:boardColor];
            self.selectedBoardColor = [UIColor colorWithHexString:boardColor];
        }
        @catch (NSException *exception)
        {
            
        }
        @finally
        {
            
        }
    }
}

#pragma mark GLMeitoBorderSelectViewControllerDelegate
- (void)didSelectedWithBorder:(NSDictionary *)borderDict
{
    self.freeBgView.image  = nil;
    if ([borderDict objectForKey:@"BorderImagePath"])
    {
        UIImage *posterImage = [UIImage imageWithContentsOfFile:[borderDict objectForKey:@"BorderImagePath"]];
        self.freeBgView.backgroundColor = [UIColor colorWithPatternImage:posterImage];
    }
}

#pragma mark - Init ScrollView
- (void)initStoryboardView
{
    _storyboardView = [[GLStoryboardSelectView alloc] initWithFrameFromPuzzle:CGRectMake(0, 0, self.bottomControlView.frame.size.width, self.bottomControlView.frame.size.height) picCount:[self.assetsImage count]];
    [_storyboardView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _storyboardView.delegateSelect = self;
    [_bottomControlView addSubview:_storyboardView];
}

- (void)initBorderView
{
    _borderView = [[GLStoryboardSelectView alloc] initWithFrameFromBorder:CGRectMake(0, 0, self.bottomControlView.frame.size.width, self.bottomControlView.frame.size.height)];
    [_borderView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _borderView.delegateSelect = self;
    [_bottomControlView addSubview:_borderView];
}

- (void)initStickerView
{
    // Sticker view
    _stickerView = [[GLStoryboardSelectView alloc] initWithFrameFromSticker:CGRectMake(0, 0, self.bottomControlView.frame.size.width, self.bottomControlView.frame.size.height)];
    [_stickerView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _stickerView.delegateSelect = self;
    [_bottomControlView addSubview:_stickerView];
}

- (void)initFaceView
{
    // Face
    _faceView = [[GLStoryboardSelectView alloc] initWithFrameFromFace:CGRectMake(0, 0, self.bottomControlView.frame.size.width, self.bottomControlView.frame.size.height)];
    [_faceView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _faceView.delegateSelect = self;
    [_bottomControlView addSubview:_faceView];
}

- (void)initFilterView
{
    _filterView = [[GLStoryboardSelectView alloc] initWithFrameFromFilter:CGRectMake(0, 0, self.bottomControlView.frame.size.width, self.bottomControlView.frame.size.height)];
    [_filterView setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
    _filterView.delegateSelect = self;
    [_bottomControlView addSubview:_filterView];
}

// Puzzle
- (void)didSelectedStoryboardPicCount:(NSInteger)picCount styleIndex:(NSInteger)styleIndex
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[LoadingViewManager sharedInstance] showLoadingViewInView:self.view withText:D_LocalizedCardString(@"Video_Processing")];
        [self contentRemoveView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self resetViewByStyleIndex:styleIndex imageCount:self.assetsImage.count];
        });
        
    });
}

// Border
- (void)didSelectedBorderIndex:(NSInteger)styleIndex
{
    if (styleIndex == 0)
    {
        self.bringPosterView.image = nil;
        self.freeBgView.backgroundColor = [UIColor whiteColor];
        return;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"border_%lu", (long)styleIndex];
    UIImage *posterImage = [UIImage imageNamed:imageName];
    posterImage = [self originImage:posterImage scaleToSize:self.contentView.frame.size];
    self.bringPosterView.image = [posterImage stretchableImageWithLeftCapWidth:posterImage.size.width/4.0f topCapHeight:160];
    self.bringPosterView.frame = self.bringPosterView.frame;
    
    self.freeBgView.image = nil;
    self.freeBgView.backgroundColor = [UIColor colorWithPatternImage:posterImage];
    self.selectedBoardColor = [UIColor colorWithPatternImage:posterImage];
}

// Sticker
- (void)didSelectedStickerIndex:(NSInteger)styleIndex
{
    NSLog(@"didSelectedStickerIndex: %ld", (long)styleIndex);
    
    NSString *imageName = [NSString stringWithFormat:@"sticker_%lu", (long)styleIndex];
    StickerView *view = [[StickerView alloc] initWithImage:[UIImage imageNamed:imageName]];
    CGFloat ratio = MIN( (0.3 * self.contentView.width) / view.width, (0.3 * self.contentView.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(self.contentView.width/2, self.contentView.height/2);
    
    [self.contentView addSubview:view];
    [StickerView setActiveStickerView:view];

    int aniTime = 0.5;
    view.alpha = 0.2;
    [UIView animateWithDuration:aniTime
                     animations:^{
                         view.alpha = 1;
                     }
     ];
}

// Face
- (void)didSelectedFaceIndex:(NSInteger)styleIndex
{
    NSLog(@"didSelectedFaceIndex: %ld", (long)styleIndex);
    
    NSString *imageName = [NSString stringWithFormat:@"face_%lu", (long)styleIndex];
    UIImage *imageFace = [UIImage imageNamed:imageName];
    StickerView *view = [[StickerView alloc] initWithImage:imageFace];
    
    CGFloat ratio = MIN( (0.3 * self.contentView.width) / view.width, (0.3 * self.contentView.height) / view.height);
    [view setScale:ratio];
    view.center = CGPointMake(self.contentView.width/2, self.contentView.height/2);
    
    [self.contentView addSubview:view];
    [StickerView setActiveStickerView:view];
}

// Filter
- (void)didSelectedFilterIndex:(NSInteger)styleIndex
{
    if (self.assets && [self.assets count] > 0)
    {
        self.freeBgView.image = nil;
        self.freeBgView.backgroundColor = self.selectedBoardColor?self.selectedBoardColor:[UIColor whiteColor];
        [LoadingViewManager showLoadViewWithText:D_LocalizedCardString(@"Video_Processing") andShimmering:YES andBlurEffect:YES inView:self.view];
        
        if (!self.assetsImage)
        {
            self.assetsImage = [[NSMutableArray alloc] initWithCapacity:1];
        }
        else
        {
            [self.assetsImage removeAllObjects];
        }
 
        for (ALAsset *asset in self.assets)
        {
            UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            UIImage *imageRelust = [self effectImage:styleIndex withImage:image];
            [self.assetsImage addObject:imageRelust];
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self resetViewByStyleIndex:self.selectStoryBoardStyleIndex imageCount:self.assetsImage.count];
            });
            
        });
    }
}

#pragma mark Filters

// lomo,黑白,怀旧,哥特,锐化,淡雅,酒红,清宁,浪漫,光晕,蓝调,梦幻,夜色
-(UIImage *)effectImage:(long)filter withImage:(UIImage*)image
{
    UIImage *imageResult = nil;
    switch (filter)
    {
        case 1:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_lomo];
            break;
        }
        case 2:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_heibai];
            break;
        }
        case 3:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_huaijiu];
            break;
        }
        case 4:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_gete];
            break;
        }
        case 5:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_danya];
            break;
        }
        case 6:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_jiuhong];
            break;
        }
        case 7:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_qingning];
            break;
        }
        case 8:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_langman];
            break;
        }
        case 9:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_guangyun];
            break;
        }
        case 10:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_landiao];
            break;
        }
        case 11:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_menghuan];
            break;
        }
        case 12:
        {
            imageResult = [ImageUtil imageWithImage:image withColorMatrix:colormatrix_yese];
            break;
        }
        default:
        {
            // Return original
            imageResult = image;
            break;
        }
    }
    
    return imageResult;
}

#pragma mark Show/Hide ScrollView

- (void)tapImageView
{
    // Deselect
    [StickerView setActiveStickerView:nil];
    [CLTextView setActiveTextView:nil];
    
    // Hide scroll view
    [self hiddenStoryboardAndPoster];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Deselect
    [StickerView setActiveStickerView:nil];
    [CLTextView setActiveTextView:nil];
    
    // Hide scroll view
    [self hiddenStoryboardAndPoster];
}

- (void)tapWithEditView:(MeituImageEditView *)sender
{
    // Deselect sticker
    [StickerView setActiveStickerView:nil];
    [CLTextView setActiveTextView:nil];
    
    // Hide scroll view
    [self hiddenStoryboardAndPoster];
}

- (void)contentRemoveView
{
    for (UIView *subView in _contentView.subviews)
    {
        // Reserve sticker view
        if (![subView isKindOfClass:[StickerView class]] && ![subView isKindOfClass:[CLTextView class]])
        {
            [subView removeFromSuperview];
        }
    }
    
    [_contentView addSubview:self.bringPosterView];
    [_contentView bringSubviewToFront:self.bringPosterView];
    
    [_contentView addSubview:self.freeBgView];
    [_contentView sendSubviewToBack:self.freeBgView];
}

- (void)bringSelectableViewToFront
{
    for (UIView *subView in _contentView.subviews)
    {
        if ([subView isKindOfClass:[StickerView class]] || [subView isKindOfClass:[CLTextView class]])
        {
            [_contentView bringSubviewToFront:subView];
        }
    }
}

#pragma mark Puzzle Style

- (void)resetViewByStyleIndex:(NSInteger)index imageCount:(NSInteger)count
{
    @synchronized(self)
    {
        self.selectStoryBoardStyleIndex = index;
        NSString *picCountFlag = @"";
        NSString *styleIndex = @"";
        
        if ([self.assetsImage count] == 1)
        {
            UIImage *image = [self.assetsImage objectAtIndex:0];
            
            CGRect rect = CGRectZero;
            rect.origin.x = 0;
            rect.origin.y = 0;
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
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            [imageView setClipsToBounds:YES];
            [imageView setBackgroundColor:[UIColor grayColor]];
            [imageView setImage:image];
            
            imageView.userInteractionEnabled = YES;
            UIGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView)];
            [imageView addGestureRecognizer:singleTap];
            
            [_contentView addSubview:imageView];
            imageView = nil;
        }
        else
        {
            switch (count)
            {
                case 2:
                    picCountFlag = @"two";
                    break;
                case 3:
                    picCountFlag = @"three";
                    break;
                case 4:
                    picCountFlag = @"four";
                    break;
                case 5:
                    picCountFlag = @"five";
                    break;
                default:
                    break;
            }
            
            switch (index)
            {
                case 1:
                    styleIndex = @"1";
                    break;
                case 2:
                    styleIndex = @"2";
                    break;
                case 3:
                    styleIndex = @"3";
                    break;
                case 4:
                    styleIndex = @"4";
                    break;
                case 5:
                    styleIndex = @"5";
                    break;
                case 6:
                    styleIndex = @"6";
                    break;
                default:
                    break;
            }
            
            NSString *styleName = [NSString stringWithFormat:@"number_%@_style_%@.plist",picCountFlag,styleIndex];
            NSDictionary *styleDict = [NSDictionary dictionaryWithContentsOfFile:
                                       [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:styleName]];
            if (styleDict)
            {
                CGSize superSize = CGSizeFromString([[styleDict objectForKey:@"SuperViewInfo"] objectForKey:@"size"]);
                superSize = [self sizeScaleWithSize:superSize scale:2.0f];
                
                NSArray *subViewArray = [styleDict objectForKey:@"SubViewArray"];
                for(int j = 0; j < [subViewArray count]; j++)
                {
                    CGRect rect = CGRectZero;
                    UIBezierPath *path = nil;
    //                ALAsset *asset = [self.assets objectAtIndex:j];
                    UIImage *image = [self.assetsImage objectAtIndex:j]; //[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                    
                    NSDictionary *subDict = [subViewArray objectAtIndex:j];
                    if([subDict objectForKey:@"frame"])
                    {
                        rect = CGRectFromString([subDict objectForKey:@"frame"]);
                        rect = [self rectScaleWithRect:rect scale:2.0f];
                        rect.origin.x = rect.origin.x * _contentView.frame.size.width/superSize.width;
                        rect.origin.y = rect.origin.y * _contentView.frame.size.height/superSize.height;
                        rect.size.width = rect.size.width * _contentView.frame.size.width/superSize.width;
                        rect.size.height = rect.size.height * _contentView.frame.size.height/superSize.height;
                    }
                    
                    rect = [self rectWithArray:[subDict objectForKey:@"pointArray"] andSuperSize:superSize];
                    if ([subDict objectForKey:@"pointArray"])
                    {
                        NSArray *pointArray = [subDict objectForKey:@"pointArray"];
                        path = [UIBezierPath bezierPath];
                        if (pointArray.count > 2)
                        {
                            // 当点的数量大于2个的时候
                            for(int i = 0; i < [pointArray count]; i++)
                            {
                                NSString *pointString = [pointArray objectAtIndex:i];
                                if (pointString)
                                {
                                    CGPoint point = CGPointFromString(pointString);
                                    point = [self pointScaleWithPoint:point scale:2.0f];
                                    point.x = (point.x)*_contentView.frame.size.width/superSize.width -rect.origin.x;
                                    point.y = (point.y)*_contentView.frame.size.height/superSize.height -rect.origin.y;
                                    if (i == 0)
                                    {
                                        [path moveToPoint:point];
                                    }
                                    else
                                    {
                                        [path addLineToPoint:point];
                                    }
                                }
                                
                            }
                        }
                        else
                        {
                            [path moveToPoint:CGPointMake(0, 0)];
                            [path addLineToPoint:CGPointMake(rect.size.width, 0)];
                            [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
                            [path addLineToPoint:CGPointMake(0, rect.size.height)];
                        }
                        
                        [path closePath];
                    }
                    
                    
                    MeituImageEditView *imageView = [[MeituImageEditView alloc] initWithFrame:rect];
                    [imageView setClipsToBounds:YES];
                    [imageView setBackgroundColor:[UIColor grayColor]];
                    imageView.tag = j;
                    imageView.realCellArea = path;
                    imageView.tapDelegate = self;
                    [imageView setImageViewData:image];
                    
                    [_contentView addSubview:imageView];
                    imageView = nil;
                }
            }
        }
        
        [_contentView bringSubviewToFront:self.bringPosterView];
        _contentView.contentSize = _contentView.frame.size;
        self.bringPosterView.frame = CGRectMake(0, 0, _contentView.contentSize.width, _contentView.contentSize.height);
        
        // Show selectable view
        [self bringSelectableViewToFront];
    }
    
    [self performSelector:@selector(hiddenWaitView) withObject:nil afterDelay:0.5];
}

- (CGRect)rectWithArray:(NSArray *)array andSuperSize:(CGSize)superSize
{
    CGRect rect = CGRectZero;
    CGFloat minX = INT_MAX;
    CGFloat maxX = 0;
    CGFloat minY = INT_MAX;
    CGFloat maxY = 0;
    for (int i = 0; i < [array count]; i++)
    {
        NSString *pointString = [array objectAtIndex:i];
        CGPoint point = CGPointFromString(pointString);
        if (point.x <= minX)
        {
            minX = point.x;
        }
        
        if (point.x >= maxX)
        {
            maxX = point.x;
        }
        
        if (point.y <= minY)
        {
            minY = point.y;
        }
        
        if (point.y >= maxY)
        {
            maxY = point.y;
        }
        rect = CGRectMake(minX, minY, maxX - minX, maxY - minY);
    }
    
    rect = [self rectScaleWithRect:rect scale:2.0f];
    rect.origin.x = rect.origin.x * _contentView.frame.size.width/superSize.width;
    rect.origin.y = rect.origin.y * _contentView.frame.size.height/superSize.height;
    rect.size.width = rect.size.width * _contentView.frame.size.width/superSize.width;
    rect.size.height = rect.size.height * _contentView.frame.size.height/superSize.height;
    
    return rect;
}

- (CGRect)rectScaleWithRect:(CGRect)rect scale:(CGFloat)scale
{
    if (scale <= 0)
    {
        scale = 1.0f;
    }
    
    CGRect retRect = CGRectZero;
    retRect.origin.x = rect.origin.x/scale;
    retRect.origin.y = rect.origin.y/scale;
    retRect.size.width = rect.size.width/scale;
    retRect.size.height = rect.size.height/scale;
    return  retRect;
}

- (CGPoint)pointScaleWithPoint:(CGPoint)point scale:(CGFloat)scale
{
    if (scale <= 0)
    {
        scale = 1.0f;
    }
    
    CGPoint retPointt = CGPointZero;
    retPointt.x = point.x/scale;
    retPointt.y = point.y/scale;
    return  retPointt;
}

- (CGSize)sizeScaleWithSize:(CGSize)size scale:(CGFloat)scale
{
    if (scale <= 0)
    {
        scale = 1.0f;
    }
    
    CGSize retSize = CGSizeZero;
    retSize.width = size.width/scale;
    retSize.height = size.height/scale;
    return  retSize;
}

#pragma mark - Loading View

- (void)showWaitView:(UIView *)inView
{
    [LoadingViewManager showLoadViewWithText:D_LocalizedCardString(@"Video_Processing") andShimmering:YES andBlurEffect:YES inView:inView];
    
    NSLog(@"showWaitView");
}

- (void)hiddenWaitView:(UIView *)inView
{
    [[LoadingViewManager sharedInstance] removeLoadingView:inView];
    
    NSLog(@"hiddenWaitView");
}

- (void)showWaitView:(NSString*)infoText hideAfterDuration:(float)duration
{
    [[LoadingViewManager sharedInstance] showHUDWithText:infoText inView:self.view duration:duration];
    
     NSLog(@"showWaitView : hideAfterDuration");
}

- (void)showWaitView
{
    [LoadingViewManager showLoadViewWithText:D_LocalizedCardString(@"Video_Processing") andShimmering:YES andBlurEffect:YES inView:self.view];
    
    NSLog(@"showWaitView");
}

- (void)hiddenWaitView
{
    [[LoadingViewManager sharedInstance] removeLoadingView:self.view];
    
    NSLog(@"hiddenWaitView");
}


#pragma mark Splice

- (void)spliceAction
{
    @synchronized(self)
    {
        [self contentRemoveView];
        
        CGRect rect = CGRectZero;
        rect.origin.x = 0;
        rect.origin.y = 10;
        for (int i = 0; i < [self.assetsImage count]; i++)
        {
//            ALAsset *asset = [self.assets objectAtIndex:i];
            UIImage *image = [self.assetsImage objectAtIndex:i]; //[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            CGFloat height = image.size.height;
            CGFloat width = image.size.width;
            rect.size.width = _contentView.frame.size.width - 20;
            rect.size.height = height*((_contentView.frame.size.width - 20)/width);
            rect.origin.x = 10;//(_contentView.frame.size.width - rect.size.width)/2.0f + 10;
            //        rect.size.width = rect.size.width - 20;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            rect.origin.y += rect.size.height+5;
            imageView.image = image;
            //      [imageView.layer setBorderWidth:2.0f];
            //      [imageView.layer setBorderColor:[UIColor clearColor].CGColor];
            //      self.selectedBoardColor == nil ?[UIColor whiteColor].CGColor:self.selectedBoardColor.CGColor];
            [_contentView addSubview:imageView];
        }
        _contentView.contentSize = CGSizeMake(_contentView.frame.size.width, rect.origin.y+5);
        
        self.freeBgView.frame = CGRectMake(0, 0, _contentView.contentSize.width, _contentView.contentSize.height);
    }
   
}

- (void)showScrollView:(ScrollViewStatus)status
{
    switch (status)
    {
        case kPuzzleScrollView:
        {
            _storyboardView.hidden = NO;
            _borderView.hidden = YES;
            _filterView.hidden = YES;
            _stickerView.hidden = YES;
            _faceView.hidden = YES;
            
            break;
        }
        case kBorderScrollView:
        {
            _borderView.hidden = NO;
            _filterView.hidden = YES;
            _storyboardView.hidden = YES;
            _stickerView.hidden = YES;
            _faceView.hidden = YES;
            
            break;
        }
        case kStickerScrollView:
        {
            _stickerView.hidden = NO;
            _filterView.hidden = YES;
            _storyboardView.hidden = YES;
            _borderView.hidden = YES;
            _faceView.hidden = YES;
            
            break;
        }
        case kFaceScrollView:
        {
            _faceView.hidden = NO;
            _stickerView.hidden = YES;
            _filterView.hidden = YES;
            _storyboardView.hidden = YES;
            _borderView.hidden = YES;
            
            break;
        }
        case kFilterScrollView:
        {
            _filterView.hidden = NO;
            _storyboardView.hidden = YES;
            _borderView.hidden = YES;
            _stickerView.hidden = YES;
            _faceView.hidden = YES;
            
            break;
        }
        default:
            break;
    }
}

#pragma mark
#pragma mark -- NavgationBar BackButton And PreviewAction

- (void)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [D_Main_Appdelegate showPreView];
}

- (void)preViewBtnAction:(id)sender
{
    // Deselect selectable view
    [StickerView setActiveStickerView:nil];
    [CLTextView setActiveTextView:nil];
    
    SharedImageViewController *sharedVC = [[SharedImageViewController alloc] init];
    sharedVC.image = [self captureScrollView:self.contentView];
    [self.navigationController pushViewController:sharedVC animated:YES];
}

- (UIImage *)captureScrollView:(UIScrollView *)scrollView
{
    UIImage* image = nil;
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 2.0);
    }
    else
    {
        UIGraphicsBeginImageContext(scrollView.contentSize);
    }
    
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = savedFrame;
    
    UIGraphicsEndImageContext();
    
    if (image != nil)
    {
        return image;
    }
    
    return nil;
}

@end
