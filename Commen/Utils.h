//
//  Utils.h
//  cardWeather
//
//  Created by April on 11/25/14.
//  Copyright (c) 2014 east. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,GradientType){
    topToBottomGtype = 0,//从上到小
    leftToRightGtype = 1,//从左到右
    upleftTolowRightGtype  = 2,//左上到右下
    uprightTolowLeftGtype  = 3,//右上到左下
};

@interface Utils : NSObject

+ (NSString*)generateURIWithURL:(NSString*)url Dictionary:(NSDictionary*)dict;

+ (UIImage*) gradientImageFromColors:(NSArray*)colors andSize:(CGSize)aSize ByType:(GradientType)aType;
@end
