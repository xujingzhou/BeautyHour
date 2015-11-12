//
//  SUIModalActionSheet.m
//  iUU
//
//  Created by apple on 4/20/11.
//  Copyright 2011 iUUMobile. All rights reserved.
//

#import "SUIModalActionSheet.h"


@implementation SUIModalActionSheet

@synthesize _buttonIndex;


- (void)showFromToolbar:(UIToolbar *)view {
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	SUIModalActionSheetDelegate *modalDelegate = [[SUIModalActionSheetDelegate alloc] initWithRunLoop:currentLoop];
	self.delegate = modalDelegate;
	
	[super showFromToolbar:view];
	
	// Wait for response
	CFRunLoopRun();
	
	_buttonIndex = modalDelegate._buttonIndex;
	[modalDelegate release];
}


- (void)showFromTabBar:(UITabBar *)view {
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	SUIModalActionSheetDelegate *modalDelegate = [[SUIModalActionSheetDelegate alloc] initWithRunLoop:currentLoop];
	self.delegate = modalDelegate;
	
	[super showFromTabBar:view];
	
	// Wait for response
	CFRunLoopRun();
	
	_buttonIndex = modalDelegate._buttonIndex;
	[modalDelegate release];
}


- (void)showInView:(UIView *)view {
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	SUIModalActionSheetDelegate *modalDelegate = [[SUIModalActionSheetDelegate alloc] initWithRunLoop:currentLoop];
	self.delegate = modalDelegate;
	
	[super showInView:view];
	
	// Wait for response
	CFRunLoopRun();
	
	_buttonIndex = modalDelegate._buttonIndex;
	[modalDelegate release];
}


@end



#pragma mark -

@implementation SUIModalActionSheetDelegate


@synthesize _buttonIndex;


- (id)initWithRunLoop:(CFRunLoopRef)runLoop {
	if (self = [super init]) {
		_currentLoop = runLoop;
	}
	return self;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	_buttonIndex = buttonIndex;
	CFRunLoopStop(_currentLoop);
}


@end
