//  CSLogCatcher.m
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

#import "CSLogCatcher.h"

void addLog(NSString *format, ...){
    if (format) {
        va_list args;
        va_start(args, format);
        
        NSString *interpolated = [[NSString alloc] initWithFormat:format arguments:args];
        
        [[CSLogCatcher sharedCatcher] addLog:@{@"format": format, @"full": interpolated}];
    }
}

@interface CSLogCatcher (PrivateMethods)
-(NSNumber *)numberOfPlaceholdersInFormatString:(NSString *)fmt;
@end

@implementation CSLogCatcher
- (void) addLog:(id)log;
{
    [_logs addObject:log];
}

+ (id)sharedCatcher;
{
    static CSLogCatcher *sharedCatcher = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCatcher = [[self alloc] init];
    });
    return sharedCatcher;
}

- (id) init;
{
    if (self = [super init]){
        _logs = [[NSMutableArray alloc] init];
    }

    return self;
}

-(void)resetLogs;
{
    _logs = [[NSMutableArray alloc] init];
}


-(BOOL)containsLogWithFormatString:(NSString *)fmt;
{
    NSUInteger index = [_logs indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSString *formatString = obj[@"format"];
        return [formatString isEqualToString:fmt];
    }];
    
    return index != NSNotFound;
}
-(BOOL)containsLogWithFullString:(NSString *)full;
{
    NSUInteger index = [_logs indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSString *fullString = obj[@"full"];
        return [fullString isEqualToString:full];
    }];
    
    return index != NSNotFound;
}
-(BOOL)containsLogWithFullStringMatching:(NSString *)full;
{
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:full
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSUInteger index = [_logs indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSString *fullString = obj[@"full"];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:fullString options:0 range:NSMakeRange(0, [fullString length])];
        return numberOfMatches > 0;
    }];
    
    return index != NSNotFound;
}

-(BOOL)containsLogWithFormatStringMatching:(NSString *)fmt;
{
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:fmt
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSUInteger index = [_logs indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSString *formatString = obj[@"format"];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:formatString options:0 range:NSMakeRange(0, [formatString length])];
        return numberOfMatches > 0;
    }];
    
    return index != NSNotFound;
}

-(BOOL)containsLogWithFormatString:(NSString *)fmt fullString:(NSString *)full;
{
    NSUInteger index = [_logs indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *fullString = obj[@"full"];
        NSString *formatString = obj[@"format"];
        return ([fullString isEqualToString:full] && [formatString isEqualToString:fmt]);
    }];
    
    return index != NSNotFound;
}

-(BOOL)containsLogWithFormatStringMatching:(NSString *)fmt fullStringMatching:(NSString *)full;
{
    
    NSError *fmtRegexError = NULL;
    
    NSRegularExpression *fmtRegex = [NSRegularExpression regularExpressionWithPattern:fmt
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&fmtRegexError];
    
    NSError *fullRegexError = NULL;
    
    NSRegularExpression *fullRegex = [NSRegularExpression regularExpressionWithPattern:full
                                                                              options:NSRegularExpressionCaseInsensitive
                                                                                error:&fullRegexError];
    
    NSUInteger index = [_logs indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *fullString = obj[@"full"];
        NSString *formatString = obj[@"format"];
        NSUInteger numberOfMatchesForFmt = [fmtRegex numberOfMatchesInString:formatString options:0 range:NSMakeRange(0, [formatString length])];
        NSUInteger numberOfMatchesForFull = [fullRegex numberOfMatchesInString:fullString options:0 range:NSMakeRange(0, [fullString length])];
        
        return (numberOfMatchesForFmt > 0 && numberOfMatchesForFull > 0);
    }];
    
    return index != NSNotFound;
}

-(NSNumber *)numberOfPlaceholdersInFormatString:(NSString *)fmt;
{
    NSString *percentPercentString = @"%%";
    NSString *percentString = @"%";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:percentPercentString options:0 error:&error];
    
    NSUInteger numberOfLiterals = [regex numberOfMatchesInString:fmt options:0 range:NSMakeRange(0, [fmt length])];
    
    regex = [NSRegularExpression regularExpressionWithPattern:percentString options:0 error:&error];
    NSUInteger maxPlaceholders = [regex numberOfMatchesInString:fmt options:0 range:NSMakeRange(0, [fmt length])];
    
    NSInteger numberOfPlaceholders = (maxPlaceholders - 2 * numberOfLiterals);
    
    return [NSNumber numberWithInteger:numberOfPlaceholders];
}

+(void)resetLogs;
{
    [[self sharedCatcher] resetLogs];
}

+(id)getLogs;
{
    return [[self sharedCatcher] logs];
}

+(BOOL)containsLogWithFormatString:(NSString *)fmt;
{
    return [[self sharedCatcher] containsLogWithFormatString:fmt];
}

+(BOOL)containsLogWithFullString:(NSString *)full;
{
    return [[self sharedCatcher] containsLogWithFullString:full];
}

+(BOOL)containsLogWithFullStringMatching:(NSString *)full;
{
    return [[self sharedCatcher] containsLogWithFullStringMatching:full];
}

+(BOOL)containsLogWithFormatStringMatching:(NSString *)full;
{
    return [[self sharedCatcher] containsLogWithFormatStringMatching:full];
}

+(BOOL)containsLogWithFormatString:(NSString *)fmt fullString:(NSString *)full;
{
    return [[self sharedCatcher] containsLogWithFormatString:fmt fullString:full];
}
+(BOOL)containsLogWithFormatStringMatching:(NSString *)fmt fullStringMatching:(NSString *)full;
{
    return [[self sharedCatcher] containsLogWithFormatStringMatching:fmt fullStringMatching:full];
}
@end
