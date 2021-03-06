//
//  TIFeedback.m
//  followme
//
//  Created by Толя Ларин on 19/01/15.
//  Copyright (c) 2015 Толя Ларин. All rights reserved.
//

#import "TIEmailFeedback.h"
#import "TITrivia.h"

@interface TIEmailFeedback()

@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSDictionary* userInfo;
@property (weak, nonatomic) UIViewController* presentingVC;
@property (strong, nonatomic) void (^doneCallback)(MFMailComposeResult);

@end

@implementation TIEmailFeedback

- (TIEmailFeedback*) initWithEmail:(NSString*) email {
    self = [super init];
    self.email = email;
    return self;
}

- (TIEmailFeedback*) initWithEmail:(NSString*) email userInfo:(NSDictionary*) userInfo {
    self = [super init];
    self.email = email;
    self.userInfo = userInfo;
    return self;
}

- (NSString*) getFooter {
    NSMutableString* basicInformationString = [NSMutableString stringWithFormat:@"\n\n\n\n----\n bundle id: %@\nversion: %@\ndevice: %@\nios: %@",
                                  [[NSBundle mainBundle] bundleIdentifier], TITrivia.versionBuild, TITrivia.deviceModel, TITrivia.iosVersion];
    if (self.userInfo != nil) {
        for (NSString* key in [self.userInfo allKeys]) {
            NSString* infoString = [NSString stringWithFormat:@"\n%@: %@", key, [self.userInfo objectForKey:key]];
            [basicInformationString appendString:infoString];
        }
    }
    return basicInformationString;
}

- (void) askFeedbackWithVC:(UIViewController*) presentingVC doneCallback:(void (^)(MFMailComposeResult))doneCallback {
    self.presentingVC = presentingVC;
    self.doneCallback = doneCallback;
    
    NSString *bundlePath = [[NSBundle bundleForClass:[TIEmailFeedback class]] pathForResource:@"TITrivia" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:@[self.email]];
        NSString* subject = [bundle localizedStringForKey:@"[%@] Feedback" value:@"" table:nil];
        [controller setSubject:[NSString stringWithFormat:subject, TITrivia.appDisplayName]];
        [controller setMessageBody:self.getFooter isHTML:NO];
        [presentingVC presentViewController:controller animated:YES completion:nil];
    } else {
        NSString* title = [bundle localizedStringForKey:@"Mail account is not configured" value:@"" table:nil];
        NSString* message = [NSString stringWithFormat:[bundle localizedStringForKey:@"Send us an email to %@" value:@"" table:nil], self.email];
        
        if([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * closeAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:closeAction];
            [presentingVC presentViewController:alert animated:TRUE completion:nil];
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    [self.presentingVC dismissViewControllerAnimated:YES completion:nil];
    if (self.doneCallback) {
        self.doneCallback(result);
    }
}

@end
