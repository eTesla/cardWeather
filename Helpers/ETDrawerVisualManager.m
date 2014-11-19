//
//  ETDrawerVisualManager.m
//  cardWeather
//
//  Created by east on 14/11/19.
//  Copyright (c) 2014年 tesla. All rights reserved.
//

#import "ETDrawerVisualManager.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark - ETDrawerVisualState
@implementation ETDrawerVisualState

+(ETDrawerControllerDrawerVisualStateBlock)slideAndScaleVisualStateBlock
{
    ETDrawerControllerDrawerVisualStateBlock visualStateBlock =
    ^(ETDrawerViewController * drawerController, ETDirection direction, CGFloat percentVisible){
        CGFloat minScale = .90;
        CGFloat scale = minScale + (percentVisible*(1.0-minScale));
        CATransform3D scaleTransform =  CATransform3DMakeScale(scale, scale, scale);
        
        CGFloat maxDistance = 50;
        CGFloat distance = maxDistance * percentVisible;
        CATransform3D translateTransform;
        UIViewController * sideDrawerViewController;
        if(direction == ETLeftDirection)
        {
            sideDrawerViewController = drawerController.leftDrawerViewController;
            translateTransform = CATransform3DMakeTranslation((maxDistance-distance), 0.0, 0.0);
        }
        else if(direction == ETRightDirection)
        {
            sideDrawerViewController = drawerController.rightDrawerViewController;
            translateTransform = CATransform3DMakeTranslation(-(maxDistance-distance), 0.0, 0.0);
        }
        
        [sideDrawerViewController.view.layer setTransform:CATransform3DConcat(scaleTransform, translateTransform)];
        [sideDrawerViewController.view setAlpha:percentVisible];
    };
    return visualStateBlock;
}

+(ETDrawerControllerDrawerVisualStateBlock)slideVisualStateBlock
{
    return [self parallaxVisualStateBlockWithParallaxFactor:1.0];
}


+(ETDrawerControllerDrawerVisualStateBlock)swingingDoorVisualStateBlock
{
    ETDrawerControllerDrawerVisualStateBlock visualStateBlock =
    ^(ETDrawerViewController * drawerController, ETDirection direction, CGFloat percentVisible){
        UIViewController * sideDrawerViewController;
        CGPoint anchorPoint = CGPointMake(0.5, 0.5);
        CGFloat maxDrawerWidth = 0.0;
        CGFloat xOffset = 0.0;
        CGFloat angle = 0.0;
        
        if(direction == ETLeftDirection){
            
            sideDrawerViewController = drawerController.leftDrawerViewController;
            anchorPoint =  CGPointMake(1.0, .5);
            maxDrawerWidth = MAX(drawerController.maximumLeftDrawerWidth,drawerController.visibleLeftDrawerWidth);
            xOffset = -(maxDrawerWidth/2.0) + (maxDrawerWidth)*percentVisible;
            angle = -M_PI_2+(percentVisible*M_PI_2);
        }
        else if(direction == ETRightDirection)
        {
            sideDrawerViewController = drawerController.rightDrawerViewController;
            anchorPoint = CGPointMake(0.0, .5);
            maxDrawerWidth = MAX(drawerController.maximumRightDrawerWidth,drawerController.visibleRightDrawerWidth);
            xOffset = (maxDrawerWidth/2.0) - (maxDrawerWidth)*percentVisible;
            angle = M_PI_2-(percentVisible*M_PI_2);
        }
        
        [sideDrawerViewController.view.layer setAnchorPoint:anchorPoint];
        [sideDrawerViewController.view.layer setShouldRasterize:YES];
        [sideDrawerViewController.view.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
        
        CATransform3D swingingDoorTransform = CATransform3DIdentity;
        if (percentVisible <= 1.f) {
            
            CATransform3D identity = CATransform3DIdentity;
            identity.m34 = -1.0/1000.0;
            CATransform3D rotateTransform = CATransform3DRotate(identity, angle, 0.0, 1.0, 0.0);
            
            CATransform3D translateTransform = CATransform3DMakeTranslation(xOffset, 0.0, 0.0);
            
            CATransform3D concatTransform = CATransform3DConcat(rotateTransform, translateTransform);
            
            swingingDoorTransform = concatTransform;
        }
        else
        {
            CATransform3D overshootTransform = CATransform3DMakeScale(percentVisible, 1.f, 1.f);
            
            NSInteger scalingModifier = 1.f;
            if (direction == ETRightDirection)
            {
                scalingModifier = -1.f;
            }
            
            overshootTransform = CATransform3DTranslate(overshootTransform, scalingModifier*maxDrawerWidth/2, 0.f, 0.f);
            swingingDoorTransform = overshootTransform;
        }
        
        [sideDrawerViewController.view.layer setTransform:swingingDoorTransform];
    };
    return visualStateBlock;
}

+(ETDrawerControllerDrawerVisualStateBlock)parallaxVisualStateBlockWithParallaxFactor:(CGFloat)parallaxFactor{
    ETDrawerControllerDrawerVisualStateBlock visualStateBlock =
    ^(ETDrawerViewController * drawerController, ETDirection direction, CGFloat percentVisible){
        NSParameterAssert(parallaxFactor >= 1.0);
        CATransform3D transform;
        UIViewController * sideDrawerViewController;
        if(direction == ETLeftDirection)
        {
            sideDrawerViewController = drawerController.leftDrawerViewController;
            CGFloat distance = MAX(drawerController.maximumLeftDrawerWidth,drawerController.visibleLeftDrawerWidth);
            if (percentVisible <= 1.f)
            {
                transform = CATransform3DMakeTranslation((-distance)/parallaxFactor+(distance*percentVisible/parallaxFactor), 0.0, 0.0);
            }
            else
            {
                transform = CATransform3DMakeScale(percentVisible, 1.f, 1.f);
                transform = CATransform3DTranslate(transform, drawerController.maximumLeftDrawerWidth*(percentVisible-1.f)/2, 0.f, 0.f);
            }
        }
        else if(direction == ETRightDirection)
        {
            sideDrawerViewController = drawerController.rightDrawerViewController;
            CGFloat distance = MAX(drawerController.maximumRightDrawerWidth,drawerController.visibleRightDrawerWidth);
            if(percentVisible <= 1.f)
            {
                transform = CATransform3DMakeTranslation((distance)/parallaxFactor-(distance*percentVisible)/parallaxFactor, 0.0, 0.0);
            }
            else
            {
                transform = CATransform3DMakeScale(percentVisible, 1.f, 1.f);
                transform = CATransform3DTranslate(transform, -drawerController.maximumRightDrawerWidth*(percentVisible-1.f)/2, 0.f, 0.f);
            }
        }
        else if(direction == ETDownDirection)
        {
            sideDrawerViewController = drawerController.bottomDrawerViewController;
            CGFloat distance = MAX(drawerController.maximumBottomDrawerHeight,drawerController.visibleBottomDrawerHeight);
            if(percentVisible <= 1.f)
            {
                transform = CATransform3DMakeTranslation(0.0, (distance)/parallaxFactor-(distance*percentVisible)/parallaxFactor, 0.0);
            }
            else
            {
                transform = CATransform3DMakeScale(1.f, percentVisible, 1.f);
                transform = CATransform3DTranslate(transform, 0.f, -drawerController.maximumBottomDrawerHeight*(percentVisible-1.f)/2, 0.f);
            }
        }
        
        [sideDrawerViewController.view.layer setTransform:transform];
    };
    return visualStateBlock;
}

@end

#pragma mark - ETDrawerVisualManager

@implementation ETDrawerVisualManager

+ (ETDrawerVisualManager *)sharedManager {
    static ETDrawerVisualManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[ETDrawerVisualManager alloc] init];
        [_sharedManager setLeftDrawerAnimationType:ETDrawerAnimationTypeParallax];
        [_sharedManager setRightDrawerAnimationType:ETDrawerAnimationTypeParallax];
    });
    
    return _sharedManager;
}

-(ETDrawerControllerDrawerVisualStateBlock)drawerVisualStateBlockForDrawerSide:(ETDirection)direction
{
    ETDrawerAnimationType animationType;
    if(direction == ETLeftDirection)
    {
        animationType = self.leftDrawerAnimationType;
    }
    else if(direction == ETRightDirection)
    {
        animationType = self.rightDrawerAnimationType;
    }
    else if(direction == ETDownDirection)
    {
        animationType = self.bottomDrawerAnimationType;
    }
    
    ETDrawerControllerDrawerVisualStateBlock visualStateBlock = nil;
    switch (animationType)
    {
        case ETDrawerAnimationTypeSlide:
            visualStateBlock = [ETDrawerVisualState slideVisualStateBlock];
            break;
        case ETDrawerAnimationTypeSlideAndScale:
            visualStateBlock = [ETDrawerVisualState slideAndScaleVisualStateBlock];
            break;
        case ETDrawerAnimationTypeParallax:
            visualStateBlock = [ETDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
            break;
        case ETDrawerAnimationTypeSwingingDoor:
            visualStateBlock = [ETDrawerVisualState swingingDoorVisualStateBlock];
            break;
        default:
            visualStateBlock =  ^(ETDrawerViewController * drawerController, ETDirection direction, CGFloat percentVisible){
                
                UIViewController * sideDrawerViewController;
                CATransform3D transform;
                CGFloat maxDrawerWidth = 0.0f;
                CGFloat maxDrawerHeight = 0.0f;
                
                if(direction == ETLeftDirection)
                {
                    sideDrawerViewController = drawerController.leftDrawerViewController;
                    maxDrawerWidth = drawerController.maximumLeftDrawerWidth;
                }
                else if(direction == ETRightDirection)
                {
                    sideDrawerViewController = drawerController.rightDrawerViewController;
                    maxDrawerWidth = drawerController.maximumRightDrawerWidth;
                }
                else if(direction == ETDownDirection)
                {
                    sideDrawerViewController = drawerController.bottomDrawerViewController;
                    maxDrawerHeight = drawerController.maximumBottomDrawerHeight;
                }
                
                if(percentVisible > 1.0){
                    transform = CATransform3DMakeScale(percentVisible, 1.f, 1.f);
                    
                    if(direction == ETLeftDirection)
                    {
                        transform = CATransform3DTranslate(transform, maxDrawerWidth*(percentVisible-1.f)/2, 0.f, 0.f);
                    }
                    else if(direction == ETRightDirection)
                    {
                        transform = CATransform3DTranslate(transform, -maxDrawerWidth*(percentVisible-1.f)/2, 0.f, 0.f);
                    }
                    else if(direction == ETDownDirection)
                    {
                        //
                    }
                }
                else
                {
                    transform = CATransform3DIdentity;
                }
                [sideDrawerViewController.view.layer setTransform:transform];
            };
            break;
    }
    return visualStateBlock;
}

@end
