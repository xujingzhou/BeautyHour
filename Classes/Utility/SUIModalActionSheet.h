//
//  SUIModalActionSheet.h
//  iUU
//
//  Created by apple on 4/20/11.
//  Copyright 2011 iUUMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>


@interface SUIModalActionSheet : UIActionSheet {
	NSInteger _buttonIndex;
}

@property (assign) NSInteger _buttonIndex;


@end




@interface SUIModalActionSheetDelegate : NSObject<UIActionSheetDelegate> {
	CFRunLoopRef _currentLoop;
	NSInteger _buttonIndex;
}

@property (assign) NSInteger _buttonIndex;

- (id)initWithRunLoop:(CFRunLoopRef)runLoop;


@end