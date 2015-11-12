
#import <UIKit/UIKit.h>


@interface Face : NSObject

@property(nonatomic, assign) CGRect bounds;
@property(nonatomic, assign) CGPoint leftEyePosition;
@property(nonatomic, assign) CGPoint rightEyePosition;
@property(nonatomic, assign) CGPoint mouthPosition;
@property(nonatomic, assign) CGFloat rotationAngle;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImageView *imageView;

@end


@interface FaceDetection : NSObject

+ (instancetype)sharedInstance;

- (NSMutableArray*)faceDetector:(UIImage*)originalImage;

@end
