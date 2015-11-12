
#import "YcKeyBoardView.h"

#define ButtonWidth 60

@interface YcKeyBoardView()<UITextViewDelegate>

@property (nonatomic,assign) CGFloat textViewWidth;
@property (nonatomic,assign) BOOL isChange;
@property (nonatomic,assign) BOOL reduce;
@property (nonatomic,assign) CGRect originalKey;
@property (nonatomic,assign) CGRect originalText;

@end

@implementation YcKeyBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self initTextView:frame];
        [self initFinishButton];
    }
    return self;
}

- (void)initTextView:(CGRect)frame
{
    self.textView = [[UITextView alloc] init];
    self.textView.delegate = self;
    CGFloat textX = kStartLocation/2;
    self.textViewWidth = frame.size.width - 3*textX - ButtonWidth;
    self.textView.frame = CGRectMake(textX, kStartLocation*0.2, self.textViewWidth, frame.size.height - 2*kStartLocation*0.2);
    self.textView.backgroundColor = [UIColor colorWithRed:233.0/255 green:232.0/255 blue:250.0/255 alpha:1.0];
    self.textView.font = [UIFont systemFontOfSize:20.0];
    [self addSubview:self.textView];
}

- (void)initFinishButton
{
    UIButton *finishbutton  = [[UIButton alloc] initWithFrame:CGRectMake(self.textView.frame.origin.x + self.textView.bounds.size.width + kStartLocation/2, self.textView.frame.origin.y, ButtonWidth, self.textView.bounds.size.height)];
    [finishbutton setBackgroundImage:[UIImage imageNamed:@"home_block_green_a"] forState:UIControlStateNormal];
    [finishbutton setTitle:D_LocalizedCardString(@"card_meitu_complete") forState:UIControlStateNormal];
    [finishbutton setClipsToBounds:YES];
    [self addSubview:finishbutton];
    
    NSString *fontName = D_LocalizedCardString(@"FontName");
    CGFloat fontSize = 16;
    [finishbutton.titleLabel setFont:[UIFont fontWithName:fontName size:fontSize]];
    [finishbutton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)finishButtonAction
{
    if([self.delegate respondsToSelector:@selector(keyBoardViewHide:textView:)])
    {
        [self.delegate keyBoardViewHide:self textView:self.textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if ([text isEqualToString:@"\n"])
//    {
//        if([self.delegate respondsToSelector:@selector(keyBoardViewHide:textView:)])
//        {
//            [self.delegate keyBoardViewHide:self textView:self.textView];
//        }
//        return NO;
//    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
//    NSString *content = textView.text;
//    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:20.0]];
//    if(contentSize.width > self.textViewWidth)
//    {
//      if(!self.isChange)
//      {
//          CGRect keyFrame = self.frame;
//          self.originalKey = keyFrame;
//          keyFrame.size.height += keyFrame.size.height;
//          keyFrame.origin.y -= keyFrame.size.height*0.25;
//          self.frame = keyFrame;
//          
//          CGRect textFrame = self.textView.frame;
//          self.originalText = textFrame;
//          textFrame.size.height += textFrame.size.height*0.5+kStartLocation*0.2;
//          self.textView.frame = textFrame;
//          self.isChange = YES;
//          self.reduce = YES;
//        }
//    }
//    
//    if(contentSize.width <= self.textViewWidth)
//    {
//        if(self.reduce)
//        {
//            self.frame = self.originalKey;
//            self.textView.frame = self.originalText;
//            self.isChange = NO;
//            self.reduce = NO;
//       }
//    }
}

@end
