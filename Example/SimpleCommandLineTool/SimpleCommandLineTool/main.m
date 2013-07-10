//
//  main.m
//  SimpleCommandLineTool
//
//  Created by Eric Allam on 7/10/13.
//  Copyright (c) 2013 Code School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSLogCatcher.h"

#define _NSLog NSLog
#define NSLog(fmt, ...) addLog(fmt, ##__VA_ARGS__); _NSLog(fmt, ##__VA_ARGS__);

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, %@", @"World");
        
        if ([CSLogCatcher containsLogWithFormatString:@"Hello, %@"]) {
            NSLog(@"Logged the correct format string");
        }
        
        if ([CSLogCatcher containsLogWithFullString:@"Hello, World"]) {
            NSLog(@"Logged the correct full string");
        }
        
    }
    return 0;
}

