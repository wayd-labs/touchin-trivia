//
//  TITrivia.h
//  followme
//
//  Created by Толя Ларин on 19/01/15.
//  Copyright (c) 2015 Толя Ларин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TITrivia : NSObject<UIAlertViewDelegate>

+ (instancetype)sharedInstance;

+ (NSString *) versionBuild;
+ (NSString *) appDisplayName;
+ (NSString *) iosVersion;
+ (NSString *) deviceModel;
+ (NSString *) appVersion;
+ (NSString *) build;

+ (NSString *) currentLanguageKey;

+ (void) showSimpleMessageWithTitle:(NSString*) title message:(NSString*) message presentingVC:(UIViewController*) presentingVC;

+ (BOOL) shouldShowVKInteraction;

@property (nonatomic, weak) UIViewController* presentingVC; //for alerts
- (void) initTrackActiveVC;

- (void) showSimpleMessageWithTitle:(NSString*) title message:(NSString*) message;

- (void) showYesNoAlertWithTitle:(NSString*) title message:(NSString*) message
                 denyButtonTitle:(NSString*) denyButtonTitle allowButtonTitle:(NSString*) allowButtonTitle
                      completion:(void (^)(BOOL allowTapped)) completionHandler;

@end
