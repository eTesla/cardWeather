//
//  UIViewController+ETDrawerController.m
//  cardWeather
//
//  Created by east on 14/11/19.
//  Copyright (c) 2014年 tesla. All rights reserved.
//

#import "UIViewController+ETDrawerController.h"

@implementation UIViewController (ETDrawerController)


-(ETDrawerViewController*)et_drawerController{
    if([self.parentViewController isKindOfClass:[ETDrawerViewController class]])
    {
        return (ETDrawerViewController*)self.parentViewController;
    }
    else if([self.parentViewController isKindOfClass:[UINavigationController class]] &&
            [self.parentViewController.parentViewController isKindOfClass:[ETDrawerViewController class]])
    {
        return (ETDrawerViewController*)[self.parentViewController parentViewController];
    }
    else
    {
        return nil;
    }
}

-(CGRect)et_visibleDrawerFrame{
    if([self isEqual:self.et_drawerController.leftDrawerViewController] ||
       [self.navigationController isEqual:self.et_drawerController.leftDrawerViewController])
    {
        CGRect rect = self.et_drawerController.view.bounds;
        rect.size.width = self.et_drawerController.maximumLeftDrawerWidth;
        return rect;
        
    }
    else if([self isEqual:self.et_drawerController.rightDrawerViewController] ||
            [self.navigationController isEqual:self.et_drawerController.rightDrawerViewController])
    {
        CGRect rect = self.et_drawerController.view.bounds;
        rect.size.width = self.et_drawerController.maximumRightDrawerWidth;
        rect.origin.x = CGRectGetWidth(self.et_drawerController.view.bounds)-rect.size.width;
        return rect;
    }
    else if([self isEqual:self.et_drawerController.bottomDrawerViewController] ||
            [self.navigationController isEqual:self.et_drawerController.bottomDrawerViewController])
    {
        CGRect rect = self.et_drawerController.view.bounds;
        rect.size.height = self.et_drawerController.maximumBottomDrawerHeight;
        rect.origin.y = CGRectGetHeight(self.et_drawerController.view.bounds)-rect.size.height;
        return rect;
    }
    else
    {
        return CGRectNull;
    }
}


@end
