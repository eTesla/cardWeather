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
#import "CoreLocation/CoreLocation.h"

const CGFloat cornersize = 20.f;

#define  BACKGROUNDCOLOR1 [UIColor colorWithRed:244.0f/255.0f green:178.0f/255.0f blue:59.0f/255.0f alpha:1.0f]
#define  BACKGROUNDCOLOR2 [UIColor colorWithRed:87.0f/255.0f green:187.0f/255.0f blue:164.0f/255.0f alpha:1.0f]
#define  BACKGROUNDCOLOR3 [UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:1.0f]

@interface AppDelegate ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //使用Storyboard初始化根界面
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"weather" bundle:nil];
    
    UIViewController * leftSideDrawerViewController = [[UIViewController alloc] init];
    leftSideDrawerViewController.view.backgroundColor = [UIColor blueColor];
        UIViewController * rightSideDrawerViewController = [[UIViewController alloc] init];
    rightSideDrawerViewController.view.backgroundColor = BACKGROUNDCOLOR3;
    
    UIViewController * bottomSideDrawerViewController = [[UIViewController alloc] init];
    bottomSideDrawerViewController.view.backgroundColor = BACKGROUNDCOLOR2;

    
    UINavigationController * navigationController = [storyBoard instantiateViewControllerWithIdentifier:@"CWTMainNavC"];
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
    
    [self startLocation];
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

-(void)startLocation{
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.locationManager.distanceFilter = 10.0f;
    
    [self.locationManager startUpdatingLocation];
    
}
//定位代理经纬度回调

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    
    
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"location ok");
    
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            
            NSLog(@"%@", [test objectForKey:@"State"]);
            NSLog(@"%@", [test objectForKey:@"Name"]);
            NSLog(@"%@", [test objectForKey:@"City"]);
            NSLog(@"%@", [test objectForKey:@"SubLocality"]);
            NSLog(@"%@", [test objectForKey:@"Country"]);
        }
        
    }];
    
    
    
}

@end
