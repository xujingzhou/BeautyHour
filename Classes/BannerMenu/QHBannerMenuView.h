
#import <UIKit/UIKit.h>

@class QHBannerMenuView;

@protocol QHBannerMenuViewDelegate <NSObject>

@required

- (NSInteger)bannerMenuView:(QHBannerMenuView *)bannerMenuView;

- (UIView *)bannerMenuView:(QHBannerMenuView *)bannerMenuView menuForRowAtIndexPath:(NSUInteger)index;

@optional

- (void)bannerMenuView:(QHBannerMenuView *)bannerMenuView didSelectRowAtIndexPath:(NSUInteger)index;

@end

typedef void (^SelectBlock) (NSUInteger index);

@interface QHBannerMenuView : UIView

@property (nonatomic, assign) id<QHBannerMenuViewDelegate> delegate;

/*
 *frame设置浮标位置及长宽
 *nWidth设置展出后增加的菜单宽带，可以动态计算传值
 */
- (id)initWithFrame:(CGRect)frame menuWidth:(float)nWidth;
/**
 *  定制按钮菜单及回调block事件
 */
- (id)initWithFrame:(CGRect)frame menuWidth:(float)nWidth buttonTitle:(NSArray *)arButtonTitle withBlock:(SelectBlock) block;
/**
 通用方式，拥有类似UITableView的回调实现
 */
- (id)initWithFrame:(CGRect)frame menuWidth:(float)nWidth delegate:(id<QHBannerMenuViewDelegate>)delegate;

@end
