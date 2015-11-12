
#import <Foundation/Foundation.h>

@interface CLSplineInterpolator : NSObject

- (id)initWithPoints:(NSArray*)points;          // points: array of CIVector
- (CIVector*)interpolatedPoint:(CGFloat)t;      // {t | 0 ≤ t ≤ 1}

@end
