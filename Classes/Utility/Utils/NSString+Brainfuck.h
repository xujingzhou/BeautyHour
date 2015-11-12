//
//  NSString+Brainfuck.h
//  Photo With Secret
//
//  Created by Sihao Lu on 6/29/13.
//  Copyright (c) 2013 Sihao Lu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Brainfuck)

/** 
 Convert string to its brainfuck code representation.
 @return brainfuck code representation
 */
- (NSString *) brainfuckCode;

/**
 Parse brainfuck code.
 @return running result
 */
- (NSString *) parseBrainfuckCode;

@end
