//  CSLogCatcher.h
//
//  Copyright (c) 2013 Code School. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

/*
  CSLogCatcher gives you the ability to easily record all the calls to NSLog within your application.

  Code School uses it for testing purposes. We expect our students to write particular NSLog calls and this
  allows us to write expectations based on the format string and the string that was outputted.

  ## Installing the CSLogCatcher into NSLog

  You can easily install the CSLogCatcher singleton instance using a macro and calling the supplied `addLog` function, like this:


      #import "CSLogCatcher.h"
      
      #define _NSLog NSLog
      #define NSLog(fmt, ...) addLog(fmt, ##__VA_ARGS__); _NSLog(fmt, ##__VA_ARGS__);


  After this point in your app, whenever NSLog is called an entry is added to the `[[CSLogCatcher sharedCatcher] logs]` NSMutableArray property.

  ## Testing for certain NSLog calls

  The `CSLogCatcher` instance exposes some methods for you if you want to check to see if a certain thing has been logged. You can test an exact format string:

      // Somewhere in the program:
      NSLog(@"Hello %@", @"World");

      [[CSLogCatcher sharedCatcher] containsLogWithFormatString:@"Hello %@"]; // YES

  Or for an exact full string (the full string is the result of NSLog interpolating the format string and placeholder variables)

      [[CSLogCatcher sharedCatcher] containsLogWithFullString:@"Hello World"]; // YES 

  If you don't need to match against the exact format/full string, you can use the `Matching:` 
  alternatives to the above methods it'll return YES if the argument string matches any part of a string that was logged:

      [[CSLogCatcher sharedCatcher] containsLogWithFormatStringMatching:@"llo"]; // YES

      [[CSLogCatcher sharedCatcher] containsLogWithFullStringMatching:@"orld"]; // YES

      [[CSLogCatcher sharedCatcher] containsLogWithFormatStringMatching:@"%@"]; // YES

  All instance methods have equivalent methods you can call directly on the class (instead of always having to call `[CSLogCatcher sharedCatcher]`):

      [CSLogCatcher containsLogWithFormatStringMatching:@"llo"]; // YES

      [CSLogCatcher containsLogWithFullStringMatching:@"orld"]; // YES

      [CSLogCatcher containsLogWithFormatStringMatching:@"%@"]; // YES

  ## Resetting the CSLogCatcher instance

  You can clear out all the recorded logs from the log catcher instance by calling `resetLogs`:

      [[CSLogCatcher sharedCatcher] resetLogs];

*/

@interface CSLogCatcher : NSObject
-(void)resetLogs;
-(void)addLog:(id)log;
-(BOOL)containsLogWithFormatString:(NSString *)fmt;
-(BOOL)containsLogWithFullString:(NSString *)full;
-(BOOL)containsLogWithFullStringMatching:(NSString *)full;
-(BOOL)containsLogWithFormatStringMatching:(NSString *)full;
-(BOOL)containsLogWithFormatString:(NSString *)fmt fullString:(NSString *)full;
-(BOOL)containsLogWithFormatStringMatching:(NSString *)fmt fullStringMatching:(NSString *)full;

+(void)resetLogs;
+(id)getLogs;
+(BOOL)containsLogWithFormatString:(NSString *)fmt;
+(BOOL)containsLogWithFullString:(NSString *)full;
+(BOOL)containsLogWithFullStringMatching:(NSString *)full;
+(BOOL)containsLogWithFormatStringMatching:(NSString *)full;
+(BOOL)containsLogWithFormatString:(NSString *)fmt fullString:(NSString *)full;
+(BOOL)containsLogWithFormatStringMatching:(NSString *)fmt fullStringMatching:(NSString *)full;

+(id)sharedCatcher;


@property NSMutableArray *logs;
@end

void addLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
