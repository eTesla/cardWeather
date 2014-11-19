//
//  ETDrawerVisualManager.h
//  cardWeather
//
//  Created by east on 14/11/19.
//  Copyright (c) 2014年 tesla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETDrawerViewController.h"

typedef NS_ENUM(NSInteger, ETDrawerAnimationType){
    ETDrawerAnimationTypeNone,
    ETDrawerAnimationTypeSlide,
    ETDrawerAnimationTypeSlideAndScale,
    ETDrawerAnimationTypeSwingingDoor,
    ETDrawerAnimationTypeParallax,
};

@interface ETDrawerVisualState : NSObject

+(ETDrawerControllerDrawerVisualStateBlock)slideAndScaleVisualStateBlock;

+(ETDrawerControllerDrawerVisualStateBlock)slideVisualStateBlock;

+(ETDrawerControllerDrawerVisualStateBlock)swingingDoorVisualStateBlock;

+(ETDrawerControllerDrawerVisualStateBlock)parallaxVisualStateBlockWithParallaxFactor:(CGFloat)parallaxFactor;

@end

@interface ETDrawerVisualManager : NSObject

@property (nonatomic,assign) ETDrawerAnimationType leftDrawerAnimationType;
@property (nonatomic,assign) ETDrawerAnimationType rightDrawerAnimationType;
@property (nonatomic,assign) ETDrawerAnimationType bottomDrawerAnimationType;

+ (ETDrawerVisualManager *)sharedManager;

-(ETDrawerControllerDrawerVisualStateBlock)drawerVisualStateBlockForDrawerSide:(ETDirection)direction;

@end
