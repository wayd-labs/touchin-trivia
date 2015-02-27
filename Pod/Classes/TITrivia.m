//
//  TITrivia.m
//  followme
//
//  Created by Толя Ларин on 19/01/15.
//  Copyright (c) 2015 Толя Ларин. All rights reserved.
//

#import "TITrivia.h"
#import <objc/runtime.h>
#import <Aspects.h>

@implementation TITrivia

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (NSString *) appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+ (NSString *) build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

+ (NSString *) versionBuild
{
    NSString * version = [self appVersion];
    NSString * build = [self build];
    
    NSString * versionBuild = [NSString stringWithFormat: @"v%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@ (%@)", versionBuild, build];
    }
    
    return versionBuild;
}

+ (NSString *) appDisplayName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *) iosVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *) deviceModel
{
    return [[UIDevice currentDevice] model];
}


+ (void) showSimpleMessageWithTitle:(NSString*) title message:(NSString*) message presentingVC:(UIViewController*) presentingVC {
    if (objc_getClass("UIAlertController") != nil) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * closeAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [presentingVC dismissViewControllerAnimated:TRUE completion:nil];
        }];
        [alert addAction:closeAction];
        [presentingVC presentViewController:alert animated:TRUE completion:nil];
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void) showSimpleMessageWithTitle:(NSString*) title message:(NSString*) message {
    [TITrivia showSimpleMessageWithTitle:title message:message presentingVC:self.presentingVC];
}

BOOL trackActiveVCEnabled = false;
void (^activeAlertCompletion)(BOOL);

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  activeAlertCompletion(buttonIndex != 0);
}

- (void) initTrackActiveVC {
  if (!trackActiveVCEnabled) {
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
      if (![aspectInfo.instance isKindOfClass:UIAlertController.class]) {
        self.presentingVC = aspectInfo.instance;
      }
      NSLog(@"%@: %@", aspectInfo.instance, aspectInfo.arguments);
    } error:NULL];
    trackActiveVCEnabled = true;
  }
}

- (void) showYesNoAlertWithTitle:(NSString*) title message:(NSString*) message
                 denyButtonTitle:(NSString*) denyButtonTitle allowButtonTitle:(NSString*) allowButtonTitle
                      completion:(void (^)(BOOL allowTapped)) completion {
  if (objc_getClass("UIAlertController") != nil) {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * closeAction = [UIAlertAction actionWithTitle:denyButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
      if (completion) {
        completion(NO);
      }
    }];
    UIAlertAction * allowAction = [UIAlertAction actionWithTitle:allowButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      if (completion) {
        completion(YES);
      }
    }];
    
    [alert addAction:closeAction];
    [alert addAction:allowAction];
    [self.presentingVC presentViewController:alert animated:TRUE completion:nil];
  } else {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:denyButtonTitle otherButtonTitles:allowButtonTitle, nil];
    activeAlertCompletion = ^void(BOOL allowTapped) {
      if (completion) {
        completion(allowTapped);
      }
    };
    [alert show];
  }
}


@end
