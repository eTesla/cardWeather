//
//  Utils.m
//  cardWeather
//
//  Created by April on 11/25/14.
//  Copyright (c) 2014 east. All rights reserved.
//

#import "Utils.h"



@implementation Utils

+ (NSString*)generateURIWithURL:(NSString*)url Dictionary:(NSDictionary*)dict
{
    NSParameterAssert(url);
    NSParameterAssert(dict);
    
    NSMutableString *uri = [NSMutableString stringWithString:url];
    
    for (NSString* key in [dict allKeys])
    {
        [uri appendFormat:@"&%@=%@", key, [dict objectForKey:key]];
    }
    
    NSRange range = [uri rangeOfString:@"&"];
    [uri replaceCharactersInRange:range withString:@"?"];
    
    return uri;
}

+ (UIImage*) gradientImageFromColors:(NSArray*)colors andSize:(CGSize)aSize ByType:(GradientType)aType{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(aSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (aType) {
        case topToBottomGtype:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, aSize.height);
            break;
        case leftToRightGtype:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(aSize.width, 0.0);
            break;
        case upleftTolowRightGtype:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(aSize.width, aSize.height);
            break;
        case uprightTolowLeftGtype:
            start = CGPointMake(aSize.width, 0.0);
            end = CGPointMake(0.0, aSize.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end
