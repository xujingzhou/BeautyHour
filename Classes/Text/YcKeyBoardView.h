
#define kStartLocation 10

#import <UIKit/UIKit.h>

@class YcKeyBoardView;
@protocol YcKeyBoardViewDelegate <NSObject>

-(void)keyBoardViewHide:(YcKeyBoardView *)keyBoardView textView:(UITextView *)contentView;
@end

@interface YcKeyBoardView : UIView
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,assign) id<YcKeyBoardViewDelegate> delegate;
@end
