//
//  TILog.m
//  Pods
//
//  Created by Aleksey Alekseenkov on 9/2/15.
//
//

#import "TILog.h"

@implementation TILog

+ (void) debug:(NSString *)msg {
#  CLS_LOG(@"%@", msg);
   NSLog(@"%@", msg);
}

+ (void) info:(NSString *)msg {
#  CLS_LOG(@"%@", msg);
   NSLog(@"%@", msg);
}

+ (void) warning:(NSString *)msg {
#  CLS_LOG(@"%@", msg);
   NSLog(@"%@", msg);
}

+ (void) error:(NSString *)msg {
#  CLS_LOG(@"%@", msg);
   NSLog(@"%@", msg);
}

@end
