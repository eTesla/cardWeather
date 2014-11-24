//
//  ETDrawerViewController.h
//  cardWeather
//
//  Created by east on 14/11/19.
//  Copyright (c) 2014年 tesla. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ETDirection){
    ETNoneDirection = 0,
    ETLeftDirection,
    ETRightDirection,
    ETDownDirection,
    ETUpDirection,
};

typedef NS_OPTIONS(NSInteger, ETOpenGestureMode) {
    ETOpenGestureModeNone                     = 0,
    ETOpenGestureModePanningNavigationBar     = 1 << 1,
    ETOpenGestureModePanningCenterView        = 1 << 2,
    ETOpenGestureModeBezelPanningCenterView   = 1 << 3,
    ETOpenGestureModeAll                      =
    ETOpenGestureModePanningNavigationBar |
    ETOpenGestureModePanningCenterView    |
    ETOpenGestureModeBezelPanningCenterView,
};

typedef NS_OPTIONS(NSInteger, ETCloseGestureMode) {
    ETCloseGestureModeNone                    = 0,
    ETCloseModePanningNavigationBar           = 1 << 1,
    ETCloseGestureModePanningCenterView       = 1 << 2,
    ETCloseGestureModeBezelPanningCenterView  = 1 << 3,
    ETCloseGestureModeTapNavigationBar        = 1 << 4,
    ETCloseGestureModeTapCenterView           = 1 << 5,
    ETCloseGestureModePanningDrawerView       = 1 << 6,
    ETCloseGestureModeAll                     =
    ETCloseModePanningNavigationBar           |
    ETCloseGestureModePanningCenterView       |
    ETCloseGestureModeBezelPanningCenterView  |
    ETCloseGestureModeTapNavigationBar        |
    ETCloseGestureModeTapCenterView           |
    ETCloseGestureModePanningDrawerView,
};

typedef NS_ENUM(NSInteger, ETDrawerOpenCenterInteractionMode) {
    ETDrawerOpenCenterInteractionModeNone,
    ETDrawerOpenCenterInteractionModeFull,
    ETDrawerOpenCenterInteractionModeNavigationBarOnly,
};


@class  ETDrawerViewController;
typedef void (^ETDrawerControllerDrawerVisualStateBlock)(ETDrawerViewController * drawerController, ETDirection direction, CGFloat percentVisible);

@interface ETDrawerViewController : UIViewController

//抽屉式主界面
@property (nonatomic, strong) UIViewController * centerViewController;

//左抽屉式界面
@property (nonatomic, strong) UIViewController * leftDrawerViewController;

//右抽屉式界面
@property (nonatomic, strong) UIViewController * rightDrawerViewController;

//底部抽屉式界面
@property (nonatomic, strong) UIViewController * bottomDrawerViewController;

//抽屉打开方向
@property (nonatomic, assign, readonly) ETDirection openDirection;

//抽屉打开效果
@property (nonatomic, assign) ETOpenGestureMode openGestureModeMask;

//抽屉关闭效果
@property (nonatomic, assign) ETCloseGestureMode closeGestureModeMask;

@property (nonatomic, assign) ETDrawerOpenCenterInteractionMode centerHiddenInteractionMode;

@property (nonatomic, assign, readonly) CGFloat visibleLeftDrawerWidth;

@property (nonatomic, assign, readonly) CGFloat visibleRightDrawerWidth;

@property (nonatomic, assign, readonly) CGFloat visibleBottomDrawerHeight;

@property (nonatomic, assign) CGFloat maximumLeftDrawerWidth;

@property (nonatomic, assign) CGFloat maximumRightDrawerWidth;

@property (nonatomic, assign) CGFloat maximumBottomDrawerHeight;

//打开/关闭抽屉每秒所移动的像素
//默认值是840
@property (nonatomic, assign) CGFloat animationVelocity;

//是否拉伸抽屉
@property (nonatomic, assign) BOOL shouldStretchDrawer;


//初始化抽屉
-(id)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController rightDrawerViewController:(UIViewController *)rightDrawerViewController bottomDrawerViewController:(UIViewController*)bottomDrawerViewController;


-(void)toggleDrawerSide:(ETDirection)direction animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

-(void)setDrawerVisualStateBlock:(void(^)(ETDrawerViewController * drawerController, ETDirection direction, CGFloat percentVisible))drawerVisualStateBlock;

-(void)setGestureCompletionBlock:(void(^)(ETDrawerViewController * drawerController, UIGestureRecognizer * gesture))gestureCompletionBlock;

@end







