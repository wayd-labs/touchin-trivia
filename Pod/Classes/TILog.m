//
//  TILog.m
//  Pods
//
//  Created by Aleksey Alekseenkov on 9/2/15.
//
//

#import "TILog.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation TILog

+ (void) debug:(NSString *)msg {
  CLS_LOG(@"%@", msg);
}

+ (void) info:(NSString *)msg {
  CLS_LOG(@"%@", msg);
}

+ (void) warning:(NSString *)msg {
  CLS_LOG(@"%@", msg);
}

+ (void) error:(NSString *)msg {
  CLS_LOG(@"%@", msg);
}

@end
