//
//  UIImage+TIImageAdditions.m
//  Pods
//
//  Created by Aleksey Alekseenkov on 2/4/15.
//
//

#import "UIImage+TIImageAdditions.h"

@implementation UIImage (TIImageAdditions)

+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake( 0, 0, size.width, size.height );
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
