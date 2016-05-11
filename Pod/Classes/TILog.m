//
//  TILog.m
//  Pods
//
//  Created by Aleksey Alekseenkov on 9/2/15.
//
//

#import "TILog.h"
#import "Crashlytics/Crashlytics.h"

@implementation TILog

//Use NSLog for Dev version of Genie and Prince. DEBUG defined flag not working

+ (void) debug:(NSString *)msg {
  NSLog(@"%@", msg);
  CLS_LOG(@"%@", msg);
}

+ (void) info:(NSString *)msg {
  NSLog(@"%@", msg);
  CLS_LOG(@"%@", msg);
}

+ (void) warning:(NSString *)msg {
  NSLog(@"%@", msg);
  CLS_LOG(@"%@", msg);
}

+ (void) error:(NSString *)msg {
  NSLog(@"%@", msg);
  CLS_LOG(@"%@", msg);
}

@end
