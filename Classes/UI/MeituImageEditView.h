
#import <UIKit/UIKit.h>
@protocol MeituImageEditViewDelegate;
@interface MeituImageEditView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, retain) UIScrollView  *contentView;
@property (nonatomic, retain) UIBezierPath *realCellArea;
@property (nonatomic, retain) UIImageView   *imageview;
@property (nonatomic, assign) id<MeituImageEditViewDelegate> tapDelegate;
- (void)setImageViewData:(UIImage *)imageData;
@end


@protocol MeituImageEditViewDelegate <NSObject>

- (void)tapWithEditView:(MeituImageEditView *)sender;

@end