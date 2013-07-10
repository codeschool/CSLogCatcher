## CSLogCatcher

CSLogCatcher gives you the ability to easily record all the calls to NSLog within your application.

Code School uses it for testing purposes. We expect our students to write particular NSLog calls and this
allows us to write expectations based on the format string and the string that was outputted.

## Usage

### Installing the CSLogCatcher into NSLog

You can easily install the CSLogCatcher singleton instance using a macro and calling the supplied `addLog` function, like this:

```objc
#import "CSLogCatcher.h"

#define _NSLog NSLog
#define NSLog(fmt, ...) addLog(fmt, ##__VA_ARGS__); _NSLog(fmt, ##__VA_ARGS__);
```


After this point in your app, whenever NSLog is called an entry is added to the `[[CSLogCatcher sharedCatcher] logs]` NSMutableArray property.

### Testing for certain NSLog calls

The `CSLogCatcher` instance exposes some methods for you if you want to check to see if a certain thing has been logged. You can test an exact format string:

```objc
// Somewhere in the program:
NSLog(@"Hello %@", @"World");

[[CSLogCatcher sharedCatcher] containsLogWithFormatString:@"Hello %@"]; // YES
```

Or for an exact full string (the full string is the result of NSLog interpolating the format string and placeholder variables)

```objc
[[CSLogCatcher sharedCatcher] containsLogWithFullString:@"Hello World"]; // YES 
```

If you don't need to match against the exact format/full string, you can use the `Matching:` 
alternatives to the above methods it'll return YES if the argument string matches any part of a string that was logged:

```objc
[[CSLogCatcher sharedCatcher] containsLogWithFormatStringMatching:@"llo"]; // YES

[[CSLogCatcher sharedCatcher] containsLogWithFullStringMatching:@"orld"]; // YES

[[CSLogCatcher sharedCatcher] containsLogWithFormatStringMatching:@"%@"]; // YES
```

All instance methods have equivalent methods you can call directly on the class (instead of always having to call `[CSLogCatcher sharedCatcher]`):

```objc
[CSLogCatcher containsLogWithFormatStringMatching:@"llo"]; // YES

[CSLogCatcher containsLogWithFullStringMatching:@"orld"]; // YES

[CSLogCatcher containsLogWithFormatStringMatching:@"%@"]; // YES
```

### Resetting the CSLogCatcher instance

You can clear out all the recorded logs from the log catcher instance by calling `resetLogs`:

```objc
[[CSLogCatcher sharedCatcher] resetLogs];
```

## Install

Just add `CSLogCatcher/` to your project

## Gotchas

There is currently no way to test for the actual placeholder objects that are sent into `NSLog`.  This could happen in the future, but it would require parsing the `NSLog` format string and correctly identifying the placeholders.  

## Credits

CSLogCatcher was created for the [Try Objective-C](http://tryobjectivec.codeschool.com) Code School course by:

- [Eric Allam](http://github.com/rubymaverick)
- [Jon Friskics](http://github.com/jonfriskics)

## License

CSLogCatcher is under the MIT license
