//  FontVC
//  BeautyHour
//
//  Created by Johnny Xu(徐景周) on 7/23/14.
//  Copyright (c) 2014 Future Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FontCallback)(BOOL success, id result);

@interface FontVC : UIViewController

@property (copy, nonatomic) FontCallback fontSuccessBlock;

@end
