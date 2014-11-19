//
//  UIViewController+ETDrawerController.h
//  cardWeather
//
//  Created by east on 14/11/19.
//  Copyright (c) 2014年 tesla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETDrawerViewController.h"

@interface UIViewController (ETDrawerController)

@property(nonatomic, strong, readonly) ETDrawerViewController *et_drawerController;

//显示的区域
@property(nonatomic, assign, readonly) CGRect et_visibleDrawerFrame;

@end
