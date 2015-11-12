//
//  NSString+Brainfuck.m
//  Photo With Secret
//
//  Created by Sihao Lu on 6/29/13.
//  Copyright (c) 2013 Sihao Lu. All rights reserved.
//

#import "NSString+Brainfuck.h"
#define MAX_CELLS 65536

@implementation NSString (Brainfuck)

- (NSString *) brainfuckCode {
    
    int asciiTotalLower = 0;
    int asciiTotalUpper = 0;
    int countSpace = 0, countUpper = 0, countLower = 0;
    for (int i = 0; i < self.length; i++) {
        if ([self characterAtIndex:i] == ' ') {
            countSpace++;
            continue;
        }
        if ([self characterAtIndex:i] <= 'Z') {
            asciiTotalUpper += [self characterAtIndex:i];
            countUpper++;
        } else {
            asciiTotalLower += [self characterAtIndex:i];
            countLower++;
        }
    }
    if (countLower != 0) asciiTotalLower /= countLower;
    if (countUpper != 0) asciiTotalUpper /= countUpper;
    
    int midLower = asciiTotalLower;
    int midUpper = asciiTotalUpper;
    
    /*
     0 - counter
     1 - upper
     2 - lower
     3 - whitespace
     */
    
    NSMutableString *result = [[NSMutableString alloc] init];
    
    if (countUpper) {
        [result appendString:@"++++++++++[>"];
        for (int j = 0; j < midUpper / 10; j++) {
            [result appendString:@"+"];
        }
        [result appendString:@"<-]>"];
        for (int i = 0; i < midUpper % 10; i++) {
            [result appendString:@"+"];
        }
        [result appendString:@"<"];
    }
    
    if (countLower) {
        [result appendString:@"++++++++++[>>"];
        for (int j = 0; j < midLower / 10; j++) {
            [result appendString:@"+"];
        }
        [result appendString:@"<<-]>>"];
        for (int i = 0; i < midLower % 10; i++) {
            [result appendString:@"+"];
        }
        [result appendString:@"<<"];
    }
    
    if (countSpace) {
        [result appendString:@"++++[>>>++++++++<<<-]"];
    }
    
    [result appendString:@">"];
    
    int location = 1;
    for (int i = 0; i < self.length; i++) {
        char current = [self characterAtIndex:i];
        if (current == ' ') {
            if (location == 1) {
                [result appendString:@">>.<<"];
            } else if (location == 2) {
                [result appendString:@">.<"];
            } else {
                [result appendString:@"."];
            }
            continue;
        }
        int diff;
        if (current <= 'Z') {
            diff = current - midUpper;
            if (location == 2) {
                [result appendString:@"<"];
                location = 1;
            }
        } else {
            diff = current - midLower;
            if (location == 1) {
                [result appendString:@">"];
                location = 2;
            }
        }
        
        if (diff >= 0) {
            for (int j = 0; j < diff; j++) {
                [result appendString:@"+"];
            }
        } else {
            for (int j = 0; j > diff; j--) {
                [result appendString:@"-"];
            }
        }
        
        if (current <= 'Z') {
            midUpper = current;
        } else {
            midLower = current;
        }
        
        [result appendString:@"."];
    }
    
    return result;
}

- (NSString *)parseBrainfuckCode {
    char c;
    int pointer = 0;
    int char_pointer = 0;
    int loop = 0;
    int tape[MAX_CELLS];
    NSMutableString *result = [[NSMutableString alloc] init];
    /* Loop through all character in the character array */
    while (char_pointer < self.length) {
        switch ([self characterAtIndex:char_pointer]) {
            case '>':
                pointer++;
                break;
            case '<':
                pointer--;
                break;
            case '+':
                tape[pointer]++;
                break;
            case '-':
                tape[pointer]--;
                break;
            case '.':
                [result appendFormat:@"%c", tape[pointer]];
                break;
            case ',':
                tape[pointer] = (int) getchar();
                break;
            case '[':
                if (tape[pointer] == 0) {
                    loop = 1;
                    while (loop > 0) {
                        c = [self characterAtIndex:++char_pointer];
                        if (c == '[')
                            loop++;
                        else if (c == ']')
                            loop--;
                    }
                }
                break;
            case ']':
                loop = 1;
                while (loop > 0) {
                    c = [self characterAtIndex:--char_pointer];
                    if (c == '[')
                        loop--;
                    else if (c == ']')
                        loop++;
                }
                char_pointer--;
                break;
        }
        char_pointer++;
    }
    return result;
}

@end
