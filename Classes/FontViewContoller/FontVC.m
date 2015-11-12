//  FontVC
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//

#import "FontVC.h"

@interface FontVC () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *fontTableView;
    NSMutableArray *fontFamilyNames;
    NSString *showText;
}

@end

@implementation FontVC

#pragma mark - System Functions
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initNavgationBar
{
    self.title = D_LocalizedCardString(@"ChangeFont");
    NSString *fontName = D_LocalizedCardString(@"FontName");
    CGFloat fontSize = 18;
    
    UIButton *backButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    [backButton setTitle:D_LocalizedCardString(@"Button_Back") forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont fontWithName:fontName size:fontSize]];
    [backButton addTarget:self
                   action:@selector(backButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Nav
    [self initNavgationBar];
    
    // Text
    showText = D_LocalizedCardString(@"FontStyleSample");
    NSArray *arrFonts = [UIFont familyNames];
    fontFamilyNames = [NSMutableArray arrayWithArray:[arrFonts sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        return [obj1 compare:obj2];
    }]];
    [fontFamilyNames insertObject:D_LocalizedCardString(@"Custom") atIndex:0];
    
    
    // Views
    fontTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    fontTableView.delegate = self;
    fontTableView.dataSource = self;
    [self.view addSubview:fontTableView];
}

#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return fontFamilyNames.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [self fontNamesOfSection:section];
    if (arr)
    {
        return arr.count;
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSString *fontName = [self fontNameOfIndexPath:indexPath];
    cell.textLabel.text = showText;
    if (indexPath.section == 0)
    {
        NSString *customFontName = [[FontVC getDefaultFonts] objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:customFontName size:15];
    }
    else
    {
        cell.textLabel.font = [UIFont fontWithName:fontName size:15];
    }
    cell.detailTextLabel.text = fontName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"Section: %ld, Row: %ld", (long)indexPath.section, (long)indexPath.row);
    
    if (self.fontSuccessBlock)
    {
        NSString *fontName = nil;
        if (indexPath.section == 0)
        {
            fontName = [[FontVC getDefaultFonts] objectAtIndex:indexPath.row];
        }
        else
        {
            fontName = [self fontNameOfIndexPath:indexPath];
        }
        
        if (!isStringEmpty(fontName))
        {
            // Dismiss view controller
            [self backButtonAction:nil];
            
            // Call back
            self.fontSuccessBlock(TRUE, fontName);
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *fontTitle = [fontFamilyNames objectAtIndex:section];
    return fontTitle;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fontName = [fontFamilyNames objectAtIndex:indexPath.section];
    if (fontName && [fontName isEqualToString:@"Zapfino"])
    {
        return 80;
    }
    else
    {
        return 50;
    }
}

#pragma mark - Private Functions
-(NSArray *)fontNamesOfSection:(NSInteger)section
{
    NSArray *ret;
    if (section == 0)
    {
        ret = [FontVC getDefaultFontsDisplayName];
    }
    else if (fontFamilyNames && section < fontFamilyNames.count)
    {
        NSString *familyName = [fontFamilyNames objectAtIndex:(section)];
        ret = [UIFont fontNamesForFamilyName:familyName];
    }
    
    return ret;
}

-(NSString *)fontNameOfIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [self fontNamesOfSection:indexPath.section];
    if (arr && indexPath.row < arr.count)
    {
        return [arr objectAtIndex:indexPath.row];
    }
    else
    {
        return nil;
    }
}

#pragma mark - Custom Fonts
+ (NSArray*)getDefaultFontsDisplayName
{
    NSArray *fontsArray = [NSArray arrayWithObjects:
                           D_LocalizedCardString(@"FontNameJingLei"),  D_LocalizedCardString(@"FontNameGirl"), D_LocalizedCardString(@"FontNameMini"), D_LocalizedCardString(@"FontNameSketchyComic"), D_LocalizedCardString(@"FontNameInkSpecial"), D_LocalizedCardString(@"FontNamePokerStyle"), D_LocalizedCardString(@"FontNameCartoon"), D_LocalizedCardString(@"FontNameMuscle"), D_LocalizedCardString(@"FontNameTeamCaptain"), D_LocalizedCardString(@"FontNameBlackJack"), D_LocalizedCardString(@"FontNameCaptureIt"), D_LocalizedCardString(@"FontNamePacifico"), D_LocalizedCardString(@"FontNameSeasideResortNF"), nil];
    
    return fontsArray;
}

+ (NSArray*)getDefaultFonts
{
    NSArray *fontsArray = [NSArray arrayWithObjects:
                           @"yolan-yolan", @"FrLt DFGirl", @"迷你简启体", @"SketchyComic", @"InkSpecial", @"Poker style", @"Cartoon Bones", @"MUSCLE_CRE", @"Team Captain", @"BlackJack", @"Capture it", @"Pacifico", @"SeasideResortNF", nil];
    
    return fontsArray;
}

// Test
-(void)showAllFonts
{
    NSArray *familyNames = [UIFont familyNames];
    for(NSString *familyName in familyNames)
    {
        NSLog(@"Family: %s \n",[familyName UTF8String]);
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        for(NSString *fontName in fontNames)
        {
            NSLog(@"\tFont: %s \n",[fontName UTF8String]);
        }
    }
}

@end
