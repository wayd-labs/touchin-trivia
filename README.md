
TouchIn-RateMe
=========
Cocoa Pod iOS library with some trivia things.

Install
=========
pod 'touchin-trivia', :git => 'https://github.com/TouchInstinct/touchin-trivia'



TIEmailFeedback
=========
Show MFMailComposeViewController with some useful info about app and device

```objectivec
    TIEmailFeedback *feedback = [[TIEmailFeedback alloc] initWithEmail:@"followme@touchin.ru"];
    [feedback askFeedbackWithVC:self doneCallback:nil];
```


TITrivia
==========
```objectivec
@interface TITrivia : NSObject

+ (NSString *) versionBuild;
+ (NSString *) appDisplayName;
+ (NSString *) iosVersion;
+ (NSString *) deviceModel;
```


TIAppearance
===========
Used for styling of TI libs components, holds two properties backgroundColor and accentColor