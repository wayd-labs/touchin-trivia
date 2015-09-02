//
//  TILog.h
//  Pods
//
//  Created by Aleksey Alekseenkov on 9/2/15.
//
//

#import <Foundation/Foundation.h>
#import <Crashlytics.h>

@interface TILog : NSObject

+ (void) debug:(NSString *)msg;
+ (void) info:(NSString *)msg;
+ (void) warning:(NSString *)msg;
+ (void) error:(NSString *)msg;

@end
