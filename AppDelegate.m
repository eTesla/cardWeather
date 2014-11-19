//
//  AppDelegate.m
//  cardWeather
//
//  Created by April on 11/18/14.
//  Copyright (c) 2014 east. All rights reserved.
//

#import "AppDelegate.h"
#import "ETDrawerViewController.h"
#import "ETDrawerVisualManager.h"

const CGFloat cornersize = 20.f;

#define  BACKGROUNDCOLOR1 [UIColor colorWithRed:244.0f/255.0f green:178.0f/255.0f blue:59.0f/255.0f alpha:1.0f]
#define  BACKGROUNDCOLOR2 [UIColor colorWithRed:87.0f/255.0f green:187.0f/255.0f blue:164.0f/255.0f alpha:1.0f]
#define  BACKGROUNDCOLOR3 [UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:1.0f]

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIViewController * leftSideDrawerViewController = [[UIViewController alloc] init];
    leftSideDrawerViewController.view.backgroundColor = [UIColor blueColor];
    
    UIViewController * centerViewController = [[UIViewController alloc] init];
    centerViewController.view.backgroundColor = BACKGROUNDCOLOR1;
    UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(centerViewController.view.frame) - cornersize, cornersize, cornersize)];
    imgV1.image = [UIImage imageNamed:@"corner-bl.png"];
    [centerViewController.view addSubview:imgV1];
    
    UIImageView *imgV2= [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(centerViewController.view.frame) - cornersize, CGRectGetMaxY(centerViewController.view.frame) - cornersize, cornersize, cornersize)];
    imgV2.image = [UIImage imageNamed:@"corner-br.png"];
    [centerViewController.view addSubview:imgV2];
    
    UIImageView *imgV3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cornersize, cornersize)];
    imgV3.image = [UIImage imageNamed:@"corner-tl.png"];
    [centerViewController.view addSubview:imgV3];
    
    UIImageView *imgV4 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(centerViewController.view.frame) - cornersize, 0, cornersize, cornersize)];
    imgV4.image = [UIImage imageNamed:@"corner-tr.png"];
    [centerViewController.view addSubview:imgV4];

    UIViewController * rightSideDrawerViewController = [[UIViewController alloc] init];
    rightSideDrawerViewController.view.backgroundColor = BACKGROUNDCOLOR3;
    
    UIViewController * bottomSideDrawerViewController = [[UIViewController alloc] init];
    bottomSideDrawerViewController.view.backgroundColor = BACKGROUNDCOLOR2;

    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    [navigationController setNavigationBarHidden:YES];
    
    ETDrawerViewController * drawerController = [[ETDrawerViewController alloc]
                                             initWithCenterViewController:navigationController
                                             leftDrawerViewController:leftSideDrawerViewController
                                             rightDrawerViewController:rightSideDrawerViewController bottomDrawerViewController:bottomSideDrawerViewController];
    [drawerController setMaximumLeftDrawerWidth:240.0];
    [drawerController setMaximumRightDrawerWidth:240.0];
    [drawerController setMaximumBottomDrawerHeight:508.0];
    
    [drawerController setOpenGestureModeMask:ETOpenGestureModeAll];
    [drawerController setCloseGestureModeMask:ETCloseGestureModeAll];
    
    [drawerController
     setDrawerVisualStateBlock:^(ETDrawerViewController *drawerController, ETDirection direction, CGFloat percentVisible) {
         ETDrawerControllerDrawerVisualStateBlock block;
         block = [[ETDrawerVisualManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:direction];
         if(block){
             block(drawerController, direction, percentVisible);
         }
     }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:drawerController];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
