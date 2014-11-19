//
//  ETDrawerViewController.m
//  cardWeather
//
//  Created by east on 14/11/19.
//  Copyright (c) 2014年 tesla. All rights reserved.
//

#import "ETDrawerViewController.h"
#import "UIViewController+ETDrawerController.h"

#pragma mark - const params
CGFloat const ETDrawerDefaultWidth = 280.0f;
CGFloat const ETDrawerDefaultHeight = 560.0f;
CGFloat const ETDrawerDefaultAnimationVelocity = 840.0f;
CGFloat const ETDrawerDefaultAnimationVelocityY = 1280.0f;

NSTimeInterval const ETDrawerDefaultFullAnimationDelay = 0.10f;

CGFloat const ETDrawerPanVelocityXAnimationThreshold = 200.0f;
CGFloat const ETDrawerPanVelocityYAnimationThreshold = 500.0f;

CGFloat const ETDrawerOvershootLinearRangePercentage = 0.75f;
CGFloat const ETDrawerOvershootPercentage = 0.1f;
NSTimeInterval const ETDrawerMinimumAnimationDuration = 0.15f;

CGFloat const ETDrawerBezelRange = 20.0f;

CGFloat const ETDrawerDefaultBounceDistance = 50.0f;

NSTimeInterval const ETDrawerDefaultBounceAnimationDuration = 0.2f;
CGFloat const ETDrawerDefaultSecondBounceDistancePercentage = .25f;

typedef void (^ETDrawerGestureCompletionBlock)(ETDrawerViewController * drawerController, UIGestureRecognizer * gesture);

static CAKeyframeAnimation * bounceKeyFrameAnimationForDistanceOnView(CGFloat distance, UIView * view) {
	CGFloat factors[32] = {0, 32, 60, 83, 100, 114, 124, 128, 128, 124, 114, 100, 83, 60, 32,
		0, 24, 42, 54, 62, 64, 62, 54, 42, 24, 0, 18, 28, 32, 28, 18, 0};
    
	NSMutableArray *values = [NSMutableArray array];
    
	for (int i=0; i<32; i++)
	{
		CGFloat positionOffset = factors[i]/128.0f * distance + CGRectGetMidX(view.bounds);
		[values addObject:@(positionOffset)];
	}
    
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
	animation.repeatCount = 1;
	animation.duration = .8;
	animation.fillMode = kCAFillModeForwards;
	animation.values = values;
	animation.removedOnCompletion = YES;
	animation.autoreverses = NO;
    
	return animation;
}


#pragma mark - ETDrawerCenterContainerView
@interface ETDrawerCenterContainerView : UIView

@property (nonatomic,assign) ETDrawerOpenCenterInteractionMode centerInteractionMode;
@property (nonatomic,assign) ETDirection openDirection;

@end

@implementation ETDrawerCenterContainerView

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView &&
       self.openDirection != ETNoneDirection)
    {
        UINavigationBar * navBar = [self navigationBarContainedWithinSubviewsOfView:self];
        CGRect navBarFrame = [navBar convertRect:navBar.frame toView:self];
        if((self.centerInteractionMode == ETDrawerOpenCenterInteractionModeNavigationBarOnly &&
            CGRectContainsPoint(navBarFrame, point) == NO) ||
           self.centerInteractionMode == ETDrawerOpenCenterInteractionModeNone)
        {
            hitView = nil;
        }
    }
    return hitView;
}

-(UINavigationBar*)navigationBarContainedWithinSubviewsOfView:(UIView*)view
{
    UINavigationBar * navBar = nil;
    for(UIView * subview in [view subviews]){
        if([view isKindOfClass:[UINavigationBar class]]){
            navBar = (UINavigationBar*)view;
            break;
        }
        else {
            navBar = [self navigationBarContainedWithinSubviewsOfView:subview];
        }
    }
    return navBar;
}
@end

#pragma mark - ETDrawerViewController

@interface ETDrawerViewController () <UIGestureRecognizerDelegate>
{
    CGFloat _maximumRightDrawerWidth;
    CGFloat _maximumLeftDrawerWidth;
    CGFloat _maximumBottomDrawerHeight;
    BOOL    _isHorizontalDirection;
    BOOL    _isVerticalDirection;
}

@property (nonatomic, assign, readwrite) ETDirection openDirection;

@property (nonatomic, strong) ETDrawerCenterContainerView * centerContainerView;

@property (nonatomic, assign) CGRect startingPanRect;
@property (nonatomic, copy) ETDrawerControllerDrawerVisualStateBlock drawerVisualState;
@property (nonatomic, copy) ETDrawerGestureCompletionBlock gestureCompletion;

@end

@interface ETDrawerViewController ()

@end

@implementation ETDrawerViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self.view setBackgroundColor:[UIColor blackColor]];
    
	[self setupGestureRecognizers];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //
    [self.centerViewController beginAppearanceTransition:YES animated:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.centerViewController endAppearanceTransition];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.centerViewController beginAppearanceTransition:NO animated:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.centerViewController endAppearanceTransition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
    {
        _isVerticalDirection = NO;
        _isHorizontalDirection = NO;
        
		[self setMaximumLeftDrawerWidth:ETDrawerDefaultWidth];
        [self setMaximumRightDrawerWidth:ETDrawerDefaultWidth];
        [self setMaximumBottomDrawerHeight:ETDrawerDefaultHeight];
        
		[self setAnimationVelocity:ETDrawerDefaultAnimationVelocity];
    
		[self setOpenGestureModeMask:ETOpenGestureModeNone];
		[self setCloseGestureModeMask:ETCloseGestureModeNone];
		[self setCenterHiddenInteractionMode:ETDrawerOpenCenterInteractionModeNavigationBarOnly];
	}
	return self;
}

-(id)initWithCenterViewController:(UIViewController *)centerViewController leftDrawerViewController:(UIViewController *)leftDrawerViewController rightDrawerViewController:(UIViewController *)rightDrawerViewController bottomDrawerViewController:(UIViewController*)bottomDrawerViewController
{
    NSParameterAssert(centerViewController);
    self = [self init];
    if(self)
    {
        [self setCenterViewController:centerViewController];
        [self setLeftDrawerViewController:leftDrawerViewController];
        [self setRightDrawerViewController:rightDrawerViewController];
        [self setBottomDrawerViewController:bottomDrawerViewController];
    }
    return self;
}

#pragma mark - Getters
-(CGFloat)maximumLeftDrawerWidth
{
    if(self.leftDrawerViewController)
    {
        return _maximumLeftDrawerWidth;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)maximumRightDrawerWidth
{
    if(self.rightDrawerViewController)
    {
        return _maximumRightDrawerWidth;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)maximumBottomDrawerHeight
{
    if(self.bottomDrawerViewController)
    {
        return _maximumBottomDrawerHeight;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)visibleLeftDrawerWidth
{
    return MAX(0.0,CGRectGetMinX(self.centerContainerView.frame));
}

-(CGFloat)visibleRightDrawerWidth
{
    if(CGRectGetMinX(self.centerContainerView.frame)<0)
    {
        return CGRectGetWidth(self.view.bounds)-CGRectGetMaxX(self.centerContainerView.frame);
    }
    else
    {
        return 0.0f;
    }
}

-(CGFloat)visibleBottomDrawerHeight
{
    if(CGRectGetMinY(self.centerContainerView.frame)<0)
    {
        return CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(self.centerContainerView.frame);
    }
    else
    {
        return 0.0f;
    }
}

#pragma mark - Setters
-(void)setRightDrawerViewController:(UIViewController *)rightDrawerViewController
{
    [self setDrawerViewController:rightDrawerViewController forSide:ETRightDirection];
}

-(void)setLeftDrawerViewController:(UIViewController *)leftDrawerViewController{
    [self setDrawerViewController:leftDrawerViewController forSide:ETLeftDirection];
}

-(void)setBottomDrawerViewController:(UIViewController *)bottomDrawerViewController{
    [self setDrawerViewController:bottomDrawerViewController forSide:ETDownDirection];
}

- (void)setDrawerViewController:(UIViewController *)viewController forSide:(ETDirection)direction
{
    NSParameterAssert(direction != ETNoneDirection);
    
    UIViewController *currentSideViewController = [self drawerViewControllerForDirection:direction];
    if (currentSideViewController != nil) {
        [currentSideViewController beginAppearanceTransition:NO animated:NO];
        [currentSideViewController.view removeFromSuperview];
        [currentSideViewController endAppearanceTransition];
        [currentSideViewController removeFromParentViewController];
    }
    
    UIViewAutoresizing autoResizingMask = 0;
    if (direction == ETLeftDirection)
    {
        _leftDrawerViewController = viewController;
        autoResizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        
    }
    else if(direction == ETRightDirection)
    {
        _rightDrawerViewController = viewController;
        autoResizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    }
    else if(direction == ETDownDirection)
    {
        _bottomDrawerViewController = viewController;
        autoResizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    }
    
    if(viewController)
    {
        [self addChildViewController:viewController];
        
        if((self.openDirection == direction) &&
           [self.view.subviews containsObject:self.centerContainerView])
        {
            [self.view insertSubview:viewController.view belowSubview:self.centerContainerView];
            [viewController beginAppearanceTransition:YES animated:NO];
            [viewController endAppearanceTransition];
        }
        else
        {
            [self.view addSubview:viewController.view];
            [self.view sendSubviewToBack:viewController.view];
            [viewController.view setHidden:YES];
        }
        
        [viewController didMoveToParentViewController:self];
        [viewController.view setAutoresizingMask:autoResizingMask];
        [viewController.view setFrame:viewController.et_visibleDrawerFrame];
    }
}

-(void)setCenterViewController:(UIViewController *)centerViewController
{
    [self setCenterViewController:centerViewController animated:NO];
}

-(void)setOpenDirection:(ETDirection)openDirection
{
    if(_openDirection != openDirection)
    {
        _openDirection = openDirection;
        [self.centerContainerView setOpenDirection:openDirection];
        if(openDirection == ETNoneDirection)
        {
            [self.leftDrawerViewController.view setHidden:YES];
            [self.rightDrawerViewController.view setHidden:YES];
            [self.bottomDrawerViewController.view setHidden:YES];
        }
    }
}

-(void)setMaximumLeftDrawerWidth:(CGFloat)maximumLeftDrawerWidth
{
    [self setMaximumLeftDrawerWidth:maximumLeftDrawerWidth animated:NO completion:nil];
}

-(void)setMaximumRightDrawerWidth:(CGFloat)maximumRightDrawerWidth
{
    [self setMaximumRightDrawerWidth:maximumRightDrawerWidth animated:NO completion:nil];
}

- (void)setMaximumBottomDrawerHeight:(CGFloat)maximumBottomDrawerHeight
{
    [self setMaximumBottomDrawerHeight:maximumBottomDrawerHeight animated:NO completion:nil];
}

#pragma mark - Size Methods
-(void)setMaximumLeftDrawerWidth:(CGFloat)width animated:(BOOL)animated completion:(void(^)(BOOL finished))completion
{
    [self setMaximumDrawerDistance:width forSide:ETLeftDirection animated:animated completion:completion];
}

-(void)setMaximumRightDrawerWidth:(CGFloat)width animated:(BOOL)animated completion:(void(^)(BOOL finished))completion{
    [self setMaximumDrawerDistance:width forSide:ETRightDirection animated:animated completion:completion];
}

-(void)setMaximumBottomDrawerHeight:(CGFloat)height animated:(BOOL)animated completion:(void(^)(BOOL finished))completion{
    [self setMaximumDrawerDistance:height forSide:ETDownDirection animated:animated completion:completion];
}

- (void)setMaximumDrawerDistance:(CGFloat)aDistance forSide:(ETDirection)direction animated:(BOOL)animated completion:(void(^)(BOOL finished))completion
{
    NSParameterAssert(aDistance > 0);
    NSParameterAssert(direction != ETNoneDirection);
    
    UIViewController *sideDrawerViewController = [self drawerViewControllerForDirection:direction];
    CGFloat oldDistance = 0.f;
    NSInteger drawerSideOriginCorrection = 1;
    
    if (direction == ETLeftDirection)
    {
        oldDistance = _maximumLeftDrawerWidth;
        _maximumLeftDrawerWidth = aDistance;
    }
    else if(direction == ETRightDirection)
    {
        oldDistance = _maximumRightDrawerWidth;
        _maximumRightDrawerWidth = aDistance;
        drawerSideOriginCorrection = -1;
    }
    else if(direction == ETDownDirection)
    {
        oldDistance = _maximumBottomDrawerHeight;
        _maximumBottomDrawerHeight = aDistance;
        drawerSideOriginCorrection = -1;
    }
    
    CGFloat distance = ABS(aDistance-oldDistance);
    NSTimeInterval duration = [self animationDurationForAnimationDistance:distance];
    
    if(self.openDirection == direction)
    {
        CGRect newCenterRect = self.centerContainerView.frame;
        if (direction == ETDownDirection)
        {
            newCenterRect.origin.y =  drawerSideOriginCorrection*aDistance;
        }
        else
        {
            newCenterRect.origin.x =  drawerSideOriginCorrection*aDistance;
        }
        [UIView
         animateWithDuration:(animated?duration:0)
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             [self.centerContainerView setFrame:newCenterRect];
             [sideDrawerViewController.view setFrame:sideDrawerViewController.et_visibleDrawerFrame];
         }
         completion:^(BOOL finished) {
             if(completion != nil){
                 completion(finished);
             }
         }];
    }
    else
    {
        [sideDrawerViewController.view setFrame:sideDrawerViewController.et_visibleDrawerFrame];
        if(completion != nil){
            completion(YES);
        }
    }
}

#pragma mark - Bounce Methods
-(void)bouncePreviewForDrawerSide:(ETDirection)direction completion:(void(^)(BOOL finished))completion
{
    NSParameterAssert(direction!=ETNoneDirection);
    [self bouncePreviewForDrawerSide:direction distance:ETDrawerDefaultBounceDistance completion:nil];
}

-(void)bouncePreviewForDrawerSide:(ETDirection)direction distance:(CGFloat)distance completion:(void(^)(BOOL finished))completion
{
    NSParameterAssert(direction!=ETNoneDirection);
    
    UIViewController * sideDrawerViewController = [self drawerViewControllerForDirection:direction];
    
    if(sideDrawerViewController == nil ||
       self.openDirection != ETNoneDirection)
    {
        if(completion)
        {
            completion(NO);
        }
        return;
    }
    else
    {
        [self prepareToPresentDrawer:direction animated:YES];
        
        [self updateDrawerVisualStateForDrawerSide:direction percentVisible:1.0];
        
        [CATransaction begin];
        [CATransaction
         setCompletionBlock:^{
             [sideDrawerViewController endAppearanceTransition];
             [sideDrawerViewController beginAppearanceTransition:NO animated:NO];
             [sideDrawerViewController endAppearanceTransition];
             if(completion){
                 completion(YES);
             }
         }];
        
        //need dispute etdowndirection
        CGFloat modifier = ((direction == ETLeftDirection)?1.0:-1.0);
        CAKeyframeAnimation *animation = bounceKeyFrameAnimationForDistanceOnView(distance*modifier,self.centerContainerView);
        [self.centerContainerView.layer addAnimation:animation forKey:@"bouncing"];
        
        [CATransaction commit];
    }
}

#pragma mark - Setting Drawer Visual State
-(void)setDrawerVisualStateBlock:(void (^)(ETDrawerViewController *, ETDirection, CGFloat))drawerVisualStateBlock
{
    [self setDrawerVisualState:drawerVisualStateBlock];
}

#pragma mark - Setting the Gesture Completion Block
-(void)setGestureCompletionBlock:(void (^)(ETDrawerViewController *, UIGestureRecognizer *))gestureCompletionBlock
{
    [self setGestureCompletion:gestureCompletionBlock];
}

#pragma mark - Animation helpers
-(void)finishAnimationForPanGestureWithVelocity:(CGPoint)velocity completion:(void(^)(BOOL finished))completion
{
    CGFloat currentOriginX = CGRectGetMinX(self.centerContainerView.frame);
    CGFloat currentOriginY = CGRectGetMinY(self.centerContainerView.frame);
    CGFloat xVelocity = velocity.x;
    CGFloat yVelocity = velocity.y;
    
    CGFloat animationVelocityX = MAX(ABS(xVelocity),ETDrawerPanVelocityXAnimationThreshold*2);
    CGFloat animationVelocityY = MAX(ABS(yVelocity),ETDrawerPanVelocityYAnimationThreshold*2);
    
    if(self.openDirection == ETLeftDirection) {
        CGFloat midPoint = self.maximumLeftDrawerWidth / 2.0;
        if(xVelocity > ETDrawerPanVelocityXAnimationThreshold)
        {
            [self openDrawerDirection:ETLeftDirection animated:YES velocity:animationVelocityX animationOptions:UIViewAnimationOptionCurveEaseOut completion:completion];
        }
        else if(xVelocity < -ETDrawerPanVelocityXAnimationThreshold)
        {
            [self closeDrawerAnimated:YES velocity:animationVelocityX animationOptions:UIViewAnimationOptionCurveEaseOut completion:completion];
        }
        else if(currentOriginX < midPoint)
        {
            [self closeDrawerAnimated:YES completion:completion];
        }
        else
        {
            [self openDrawerDirection:ETLeftDirection animated:YES completion:completion];
        }
    }
    else if(self.openDirection == ETRightDirection)
    {
        currentOriginX = CGRectGetMaxX(self.centerContainerView.frame);
        CGFloat midPoint = (CGRectGetWidth(self.view.bounds)-self.maximumRightDrawerWidth) + (self.maximumRightDrawerWidth / 2.0);
        if(xVelocity > ETDrawerPanVelocityXAnimationThreshold)
        {
            [self closeDrawerAnimated:YES velocity:animationVelocityX animationOptions:UIViewAnimationOptionCurveEaseOut completion:completion];
        }
        else if (xVelocity < -ETDrawerPanVelocityXAnimationThreshold)
        {
            [self openDrawerDirection:ETRightDirection animated:YES velocity:animationVelocityX animationOptions:UIViewAnimationOptionCurveEaseOut completion:completion];
        }
        else if(currentOriginX > midPoint)
        {
            [self closeDrawerAnimated:YES completion:completion];
        }
        else
        {
            [self openDrawerDirection:ETRightDirection animated:YES completion:completion];
        }
    }
    else if(self.openDirection == ETDownDirection)
    {
        currentOriginY = CGRectGetMaxY(self.centerContainerView.frame);
        CGFloat midPoint = (CGRectGetHeight(self.view.bounds)-self.maximumBottomDrawerHeight) + (self.maximumBottomDrawerHeight / 2.0);
        if(yVelocity > ETDrawerPanVelocityYAnimationThreshold)
        {
            [self closeDrawerAnimated:YES velocity:animationVelocityY animationOptions:UIViewAnimationOptionCurveEaseOut completion:completion];
        }
        else if (yVelocity < -ETDrawerPanVelocityYAnimationThreshold)
        {
            [self openDrawerDirection:ETDownDirection animated:YES velocity:animationVelocityY animationOptions:UIViewAnimationOptionCurveEaseOut completion:completion];
        }
        else if(currentOriginY > midPoint)
        {
            [self closeDrawerAnimated:YES completion:completion];
        }
        else
        {
            [self openDrawerDirection:ETDownDirection animated:YES completion:completion];
        }
    }
    else {
        if(completion){
            completion(NO);
        }
    }
}

-(void)updateDrawerVisualStateForDrawerSide:(ETDirection)drawerDirection percentVisible:(CGFloat)percentVisible
{
    if(self.drawerVisualState)
    {
        self.drawerVisualState(self,drawerDirection,percentVisible);
    }
    else if(self.shouldStretchDrawer)
    {
        [self applyOvershootScaleTransformForDrawerSide:drawerDirection percentVisible:percentVisible];
    }
}

- (void)applyOvershootScaleTransformForDrawerSide:(ETDirection)direction percentVisible:(CGFloat)percentVisible{
    
    if (percentVisible >= 1.f) {
        CATransform3D transform;
        UIViewController * sideDrawerViewController = [self drawerViewControllerForDirection:direction];
        if(direction == ETLeftDirection)
        {
            transform = CATransform3DMakeScale(percentVisible, 1.f, 1.f);
            transform = CATransform3DTranslate(transform, self.maximumLeftDrawerWidth*(percentVisible-1.f)/2, 0.f, 0.f);
        }
        else if(direction == ETRightDirection)
        {
            transform = CATransform3DMakeScale(percentVisible, 1.f, 1.f);
            transform = CATransform3DTranslate(transform, -self.maximumRightDrawerWidth*(percentVisible-1.f)/2, 0.f, 0.f);
        }
        else if(direction == ETDownDirection)
        {
            //
        }
        
        sideDrawerViewController.view.layer.transform = transform;
    }
}

-(void)resetDrawerVisualStateForDrawerSide:(ETDirection)direction
{
    UIViewController * sideDrawerViewController = [self drawerViewControllerForDirection:direction];
    
    [sideDrawerViewController.view.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
    [sideDrawerViewController.view.layer setTransform:CATransform3DIdentity];
    [sideDrawerViewController.view setAlpha:1.0];
}

-(CGFloat)roundedOriginXForDrawerConstriants:(CGFloat)originX{
    
    if (originX < -self.maximumRightDrawerWidth)
    {
        if (self.shouldStretchDrawer &&
            self.rightDrawerViewController)
        {
            CGFloat maxOvershoot = (CGRectGetWidth(self.centerContainerView.frame)-self.maximumRightDrawerWidth)*ETDrawerOvershootPercentage;
            return originXForDrawerOriginAndTargetOriginOffset(originX, -self.maximumRightDrawerWidth, maxOvershoot);
        }
        else
        {
            return -self.maximumRightDrawerWidth;
        }
    }
    else if(originX > self.maximumLeftDrawerWidth)
    {
        if (self.shouldStretchDrawer &&
            self.leftDrawerViewController)
        {
            CGFloat maxOvershoot = (CGRectGetWidth(self.centerContainerView.frame)-self.maximumLeftDrawerWidth)*ETDrawerOvershootPercentage;
            return originXForDrawerOriginAndTargetOriginOffset(originX, self.maximumLeftDrawerWidth, maxOvershoot);
        }
        else
        {
            return self.maximumLeftDrawerWidth;
        }
    }
    
    return originX;
}

-(CGFloat)roundedOriginYForDrawerConstriants:(CGFloat)originY{
    
    if (originY < -self.maximumBottomDrawerHeight)
    {
        return -self.maximumBottomDrawerHeight;
    }
    else if(originY > self.maximumBottomDrawerHeight)
    {
        return self.maximumBottomDrawerHeight;
    }
    
    return originY;
}

static inline CGFloat originXForDrawerOriginAndTargetOriginOffset(CGFloat originX, CGFloat targetOffset, CGFloat maxOvershoot){
    CGFloat delta = ABS(originX - targetOffset);
    CGFloat maxLinearPercentage = ETDrawerOvershootLinearRangePercentage;
    CGFloat nonLinearRange = maxOvershoot * maxLinearPercentage;
    CGFloat nonLinearScalingDelta = (delta - nonLinearRange);
    CGFloat overshoot = nonLinearRange + nonLinearScalingDelta * nonLinearRange/sqrt(pow(nonLinearScalingDelta,2.f) + 15000);
    
    if (delta < nonLinearRange)
    {
        return originX;
    }
    else if (targetOffset < 0)
    {
        return targetOffset - round(overshoot);
    }
    else
    {
        return targetOffset + round(overshoot);
    }
}


#pragma mark - Helpers
-(void)setupGestureRecognizers{
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [pan setDelegate:self];
    [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];
}

-(void)prepareToPresentDrawer:(ETDirection)direction animated:(BOOL)animated{
    ETDirection drawerToHide = ETNoneDirection;
    if(direction == ETLeftDirection)
    {
        drawerToHide = ETRightDirection;
    }
    else if(direction == ETRightDirection)
    {
        drawerToHide = ETLeftDirection;
    }
    
    UIViewController * sideDrawerViewControllerToPresent = [self drawerViewControllerForDirection:direction];
    UIViewController * sideDrawerViewControllerToHide = [self drawerViewControllerForDirection:drawerToHide];
    
    [self.view sendSubviewToBack:sideDrawerViewControllerToHide.view];
    [sideDrawerViewControllerToHide.view setHidden:YES];
    [sideDrawerViewControllerToPresent.view setHidden:NO];
    [self resetDrawerVisualStateForDrawerSide:direction];
    [sideDrawerViewControllerToPresent.view setFrame:sideDrawerViewControllerToPresent.et_visibleDrawerFrame];
    [self updateDrawerVisualStateForDrawerSide:direction percentVisible:0.0];
    [sideDrawerViewControllerToPresent beginAppearanceTransition:YES animated:animated];
}

-(UIViewController*)drawerViewControllerForDirection:(ETDirection)direction
{
    UIViewController * sideDrawerViewController = nil;
    if(direction == ETLeftDirection)
    {
        sideDrawerViewController = self.leftDrawerViewController;
    }
    else if(direction == ETRightDirection)
    {
        sideDrawerViewController = self.rightDrawerViewController;
    }
    else if(direction == ETDownDirection)
    {
        sideDrawerViewController = self.bottomDrawerViewController;
    }
    
    return sideDrawerViewController;
}

-(NSTimeInterval)animationDurationForAnimationDistance:(CGFloat)distance
{
    NSTimeInterval duration = MAX(distance/self.animationVelocity,ETDrawerMinimumAnimationDuration);
    return duration;
}


#pragma mark - Updating the Center View Controller
-(void)setCenterViewController:(UIViewController *)centerViewController animated:(BOOL)animated
{
    if(_centerContainerView == nil)
    {
        _centerContainerView = [[ETDrawerCenterContainerView alloc] initWithFrame:self.view.bounds];
        [self.centerContainerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.centerContainerView setBackgroundColor:[UIColor clearColor]];
        [self.centerContainerView setOpenDirection:self.openDirection];
        [self.centerContainerView setCenterInteractionMode:self.centerHiddenInteractionMode];
        [self.view addSubview:self.centerContainerView];
    }
    
    UIViewController * oldCenterViewController = self.centerViewController;
    if(oldCenterViewController){
        if(animated == NO)
        {
            [oldCenterViewController beginAppearanceTransition:NO animated:NO];
        }
        [oldCenterViewController removeFromParentViewController];
        [oldCenterViewController.view removeFromSuperview];
        if(animated == NO){
            [oldCenterViewController endAppearanceTransition];
        }
    }
    
    _centerViewController = centerViewController;
    
    [self addChildViewController:self.centerViewController];
    [self.centerViewController.view setFrame:self.view.bounds];
    [self.centerContainerView addSubview:self.centerViewController.view];
    [self.view bringSubviewToFront:self.centerContainerView];
    [self.centerViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    if(animated == NO)
    {
        [self.centerViewController beginAppearanceTransition:YES animated:NO];
        [self.centerViewController endAppearanceTransition];
        [self.centerViewController didMoveToParentViewController:self];
    }
}

-(void)setCenterViewController:(UIViewController *)newCenterViewController withCloseAnimation:(BOOL)animated completion:(void(^)(BOOL))completion
{
    UIViewController * currentCenterViewController = self.centerViewController;
    [currentCenterViewController beginAppearanceTransition:NO animated:NO];
    [self setCenterViewController:newCenterViewController animated:animated];
    [currentCenterViewController endAppearanceTransition];
    
    if(self.openDirection != ETNoneDirection)
    {
        [self updateDrawerVisualStateForDrawerSide:self.openDirection percentVisible:1.0];
        [self.centerViewController beginAppearanceTransition:YES animated:animated];
        [self
         closeDrawerAnimated:animated
         completion:^(BOOL finished) {
             [self.centerViewController endAppearanceTransition];
             [self.centerViewController didMoveToParentViewController:self];
             if(completion){
                 completion(finished);
             }
         }];
    }
    else
    {
        [self.centerViewController beginAppearanceTransition:YES animated:NO];
        [self.centerViewController endAppearanceTransition];
        [self.centerViewController didMoveToParentViewController:self];
        if(completion) {
            completion(NO);
        }
    }
}

-(void)setCenterViewController:(UIViewController *)newCenterViewController withFullCloseAnimation:(BOOL)animated completion:(void(^)(BOOL))completion
{
    if(self.openDirection != ETNoneDirection)
    {
        
        UIViewController * sideDrawerViewController = [self drawerViewControllerForDirection:self.openDirection];
        
        CGFloat targetClosePoint = 0.0f;
        if(self.openDirection == ETRightDirection)
        {
            targetClosePoint = -CGRectGetWidth(self.view.bounds);
        }
        else if(self.openDirection == ETLeftDirection)
        {
            targetClosePoint = CGRectGetWidth(self.view.bounds);
        }
        else if(self.openDirection == ETDownDirection)
        {
            targetClosePoint = CGRectGetWidth(self.view.bounds);
        }
        
        CGFloat distance = ABS(self.centerContainerView.frame.origin.x-targetClosePoint);
        NSTimeInterval firstDuration = [self animationDurationForAnimationDistance:distance];
        
        CGRect newCenterRect = self.centerContainerView.frame;
        
        UIViewController * oldCenterViewController = self.centerViewController;
        [oldCenterViewController beginAppearanceTransition:NO animated:animated];
        newCenterRect.origin.x = targetClosePoint;
        [UIView
         animateWithDuration:firstDuration
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             [self.centerContainerView setFrame:newCenterRect];
             [sideDrawerViewController.view setFrame:self.view.bounds];
         }
         completion:^(BOOL finished) {
             
             CGRect oldCenterRect = self.centerContainerView.frame;
             [self setCenterViewController:newCenterViewController animated:animated];
             [oldCenterViewController endAppearanceTransition];
             [self.centerContainerView setFrame:oldCenterRect];
             [self updateDrawerVisualStateForDrawerSide:self.openDirection percentVisible:1.0];
             [self.centerViewController beginAppearanceTransition:YES animated:animated];
             [sideDrawerViewController beginAppearanceTransition:NO animated:animated];
             [UIView
              animateWithDuration:[self animationDurationForAnimationDistance:CGRectGetWidth(self.view.bounds)]
              delay:ETDrawerDefaultFullAnimationDelay
              options:UIViewAnimationOptionCurveEaseInOut
              animations:^{
                  [self.centerContainerView setFrame:self.view.bounds];
                  [self updateDrawerVisualStateForDrawerSide:self.openDirection percentVisible:0.0];
              }
              completion:^(BOOL finished) {
                  [self.centerViewController endAppearanceTransition];
                  [self.centerViewController didMoveToParentViewController:self];
                  [sideDrawerViewController endAppearanceTransition];
                  [self resetDrawerVisualStateForDrawerSide:self.openDirection];
                  
                  [sideDrawerViewController.view setFrame:sideDrawerViewController.et_visibleDrawerFrame];
                  
                  [self setOpenDirection:ETNoneDirection];
                  
                  if(completion){
                      completion(finished);
                  }
              }];
         }];
    }
    else
    {
        [self setCenterViewController:newCenterViewController animated:animated];
    }
}

#pragma mark - Gesture Handlers
-(void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    if(self.openDirection != ETNoneDirection)
    {
        [self closeDrawerAnimated:YES completion:^(BOOL finished)
        {
            if(self.gestureCompletion){
                self.gestureCompletion(self, tapGesture);
            }
        }];
    }
}

-(void)panGesture:(UIPanGestureRecognizer *)panGesture{
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
            self.startingPanRect = self.centerContainerView.frame;
        case UIGestureRecognizerStateChanged:
        {
            CGRect newFrame = self.startingPanRect;
            CGPoint translatedPoint = [panGesture translationInView:self.centerContainerView];
            CGFloat distanceX = ABS(translatedPoint.x);
            CGFloat distanceY = ABS(translatedPoint.y);
            if (distanceX >= distanceY)
            {
                if (!_isVerticalDirection)
                {
                    _isHorizontalDirection = YES;
                }
            }
            else
            {
                if (!_isHorizontalDirection)
                {
                    _isVerticalDirection = YES;
                }
            }
            
            if (_isHorizontalDirection)
            {
                newFrame.origin.x = [self roundedOriginXForDrawerConstriants:CGRectGetMinX(self.startingPanRect)+translatedPoint.x];
            }
            else if (_isVerticalDirection)
            {
                newFrame.origin.y = [self roundedOriginYForDrawerConstriants:CGRectGetMinY(self.startingPanRect)+translatedPoint.y];
            }
            newFrame = CGRectIntegral(newFrame);
            CGFloat xOffset = newFrame.origin.x;
            CGFloat yOffset = newFrame.origin.y;
            
            ETDirection vDirection = ETNoneDirection;
            CGFloat percentVisible = 0.0;
            if(xOffset > 0)
            {
                vDirection = ETLeftDirection;
                percentVisible = xOffset/self.maximumLeftDrawerWidth;
            }
            else if(xOffset < 0)
            {
                vDirection = ETRightDirection;
                percentVisible = ABS(xOffset)/self.maximumRightDrawerWidth;
            }
            else if(yOffset < 0)
            {
                vDirection = ETDownDirection;
                percentVisible = ABS(yOffset)/self.maximumBottomDrawerHeight;
                newFrame.origin.y = [self roundedOriginYForDrawerConstriants:CGRectGetMinY(self.startingPanRect)+translatedPoint.y];
            }
            
            newFrame = CGRectIntegral(newFrame);
            
            UIViewController * visibleSideDrawerViewController = [self drawerViewControllerForDirection:vDirection];
            
            if(self.openDirection != vDirection)
            {
                //Handle disappearing the visible drawer
                UIViewController * sideDrawerViewController = [self drawerViewControllerForDirection:self.openDirection];
                [sideDrawerViewController beginAppearanceTransition:NO animated:NO];
                [sideDrawerViewController endAppearanceTransition];
                
                //Drawer is about to become visible
                [self prepareToPresentDrawer:vDirection animated:NO];
                [visibleSideDrawerViewController endAppearanceTransition];
                [self setOpenDirection:vDirection];
            }
            else if(vDirection == ETNoneDirection){
                [self setOpenDirection:ETNoneDirection];
            }
            
            [self updateDrawerVisualStateForDrawerSide:vDirection percentVisible:percentVisible];
            
            [self.centerContainerView setCenter:CGPointMake(CGRectGetMidX(newFrame), CGRectGetMidY(newFrame))];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            self.startingPanRect = CGRectNull;
            
            CGPoint velocity = [panGesture velocityInView:self.view];
            [self finishAnimationForPanGestureWithVelocity:velocity completion:^(BOOL finished) {
                if(self.gestureCompletion)
                {
                    self.gestureCompletion(self, panGesture);
                }
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self.view];
    
    if(self.openDirection == ETNoneDirection)
    {
        ETOpenGestureMode possibleOpenGestureModes = [self possibleOpenGestureModesForGestureRecognizer:gestureRecognizer withTouchPoint:point];
        return ((self.openGestureModeMask & possibleOpenGestureModes)>0);
    }
    else
    {
        ETCloseGestureMode possibleCloseGestureModes = [self possibleCloseGestureModesForGestureRecognizer:gestureRecognizer withTouchPoint:point];
        return ((self.closeGestureModeMask & possibleCloseGestureModes)>0);
    }
}

#pragma mark Gesture Recogizner Delegate Helpers
-(ETCloseGestureMode)possibleCloseGestureModesForGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer withTouchPoint:(CGPoint)point
{
    ETCloseGestureMode possibleCloseGestureModes = ETCloseGestureModeNone;
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        if([self isPointContainedWithinNavigationRect:point])
        {
            possibleCloseGestureModes |= ETCloseGestureModeTapNavigationBar;
        }
        if([self isPointContainedWithinCenterViewContentRect:point])
        {
            possibleCloseGestureModes |= ETCloseGestureModeTapCenterView;
        }
    }
    else if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        if([self isPointContainedWithinNavigationRect:point])
        {
            possibleCloseGestureModes |= ETCloseGestureModeTapNavigationBar;
        }
        if([self isPointContainedWithinCenterViewContentRect:point])
        {
            possibleCloseGestureModes |= ETCloseGestureModeTapCenterView;
        }
        if([self isPointContainedWithinBezelRect:point])
        {
            possibleCloseGestureModes |= ETCloseGestureModeBezelPanningCenterView;
        }
        if([self isPointContainedWithinCenterViewContentRect:point] == NO &&
           [self isPointContainedWithinNavigationRect:point] == NO)
        {
            possibleCloseGestureModes |= ETCloseGestureModePanningDrawerView;
        }
    }
    return possibleCloseGestureModes;
}

-(ETOpenGestureMode)possibleOpenGestureModesForGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer withTouchPoint:(CGPoint)point
{
    ETOpenGestureMode possibleOpenGestureModes = ETOpenGestureModeNone;
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        if([self isPointContainedWithinNavigationRect:point]){
            possibleOpenGestureModes |= ETOpenGestureModePanningNavigationBar;
        }
        if([self isPointContainedWithinCenterViewContentRect:point])
        {
            possibleOpenGestureModes |= ETOpenGestureModePanningCenterView;
        }
        if([self isPointContainedWithinBezelRect:point])
        {
            possibleOpenGestureModes |= ETOpenGestureModeBezelPanningCenterView;
        }
    }
    return possibleOpenGestureModes;
}

-(BOOL)isPointContainedWithinNavigationRect:(CGPoint)point{
    CGRect navigationBarRect = CGRectNull;
    if([self.centerViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationBar * navBar = [(UINavigationController*)self.centerViewController navigationBar];
        navigationBarRect = [navBar convertRect:navBar.frame toView:self.view];
        navigationBarRect = CGRectIntersection(navigationBarRect,self.view.bounds);
    }
    return CGRectContainsPoint(navigationBarRect,point);
}

-(BOOL)isPointContainedWithinCenterViewContentRect:(CGPoint)point
{
    CGRect centerViewContentRect = self.centerContainerView.frame;
    centerViewContentRect = CGRectIntersection(centerViewContentRect,self.view.bounds);
    return (CGRectContainsPoint(centerViewContentRect, point) &&
            [self isPointContainedWithinNavigationRect:point] == NO);
}

-(BOOL)isPointContainedWithinBezelRect:(CGPoint)point
{
    CGRect leftBezelRect;
    CGRect tempRect;
    CGRectDivide(self.view.bounds, &leftBezelRect, &tempRect, ETDrawerBezelRange, CGRectMinXEdge);
    
    CGRect rightBezelRect;
    CGRectDivide(self.view.bounds, &rightBezelRect, &tempRect, ETDrawerBezelRange, CGRectMaxXEdge);
    
    return ((CGRectContainsPoint(leftBezelRect, point) ||
             CGRectContainsPoint(rightBezelRect, point)) &&
            [self isPointContainedWithinCenterViewContentRect:point]);
}

#pragma mark - Open/Close methods
-(void)toggleDrawerSide:(ETDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    NSParameterAssert(direction!=ETNoneDirection);
    if(self.openDirection == ETNoneDirection)
    {
        [self openDrawerDirection:direction animated:animated completion:completion];
    }
    else
    {
        if((direction == ETLeftDirection &&
            self.openDirection == ETLeftDirection)
           || (direction == ETRightDirection &&
            self.openDirection == ETRightDirection)
           || (direction == ETDownDirection &&
               self.openDirection == ETDownDirection))
        {
               [self closeDrawerAnimated:animated completion:completion];
        }
        else if(completion)
        {
            completion(NO);
        }
    }
}

-(void)closeDrawerAnimated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    [self closeDrawerAnimated:animated velocity:self.animationVelocity animationOptions:UIViewAnimationOptionCurveEaseInOut completion:completion];
}

-(void)closeDrawerAnimated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion
{
    CGRect newFrame = self.view.bounds;
    
    CGFloat distance = ABS(CGRectGetMinX(self.centerContainerView.frame));
    NSTimeInterval duration = MAX(distance/ABS(velocity),ETDrawerMinimumAnimationDuration);
    
    BOOL leftDrawerVisible = CGRectGetMinX(self.centerContainerView.frame) > 0;
    BOOL rightDrawerVisible = CGRectGetMinX(self.centerContainerView.frame) < 0;
    BOOL bottomDrawerVisible = CGRectGetMinY(self.centerContainerView.frame) < 0;
    
    ETDirection visibleSide = ETNoneDirection;
    CGFloat percentVisble = 0.0;
    
    if(leftDrawerVisible)
    {
        CGFloat visibleDrawerPoints = CGRectGetMinX(self.centerContainerView.frame);
        percentVisble = MAX(0.0,visibleDrawerPoints/self.maximumLeftDrawerWidth);
        visibleSide = ETLeftDirection;
    }
    else if(rightDrawerVisible)
    {
        CGFloat visibleDrawerPoints = CGRectGetWidth(self.centerContainerView.frame)-CGRectGetMaxX(self.centerContainerView.frame);
        percentVisble = MAX(0.0,visibleDrawerPoints/self.maximumRightDrawerWidth);
        visibleSide = ETRightDirection;
    }
    else if(bottomDrawerVisible)
    {
        CGFloat visibleDrawerPoints = CGRectGetHeight(self.centerContainerView.frame)-CGRectGetMaxY(self.centerContainerView.frame);
        percentVisble = MAX(0.0,visibleDrawerPoints/self.maximumBottomDrawerHeight);
        visibleSide = ETDownDirection;
        distance = ABS(CGRectGetMinY(self.centerContainerView.frame));
        duration = MAX(distance/ABS(ETDrawerDefaultAnimationVelocityY),ETDrawerMinimumAnimationDuration);
    }
    
    UIViewController * sideDrawerViewController = [self drawerViewControllerForDirection:visibleSide];
    
    [self updateDrawerVisualStateForDrawerSide:visibleSide percentVisible:percentVisble];
    
    [sideDrawerViewController beginAppearanceTransition:NO animated:animated];
    
    [UIView
     animateWithDuration:(animated?duration:0.0)
     delay:0.0
     options:options
     animations:^{
         [self.centerContainerView setFrame:newFrame];
         [self updateDrawerVisualStateForDrawerSide:visibleSide percentVisible:0.0];
     }
     completion:^(BOOL finished) {
         [sideDrawerViewController endAppearanceTransition];
         
         _isVerticalDirection = NO;
         _isHorizontalDirection = NO;
         [self setOpenDirection:ETNoneDirection];
         [self resetDrawerVisualStateForDrawerSide:visibleSide];
         
         if(completion){
             completion(finished);
         }
     }];
}

-(void)openDrawerDirection:(ETDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL))completion{
    NSParameterAssert(direction != ETNoneDirection);
    
    [self openDrawerDirection:direction animated:animated velocity:self.animationVelocity animationOptions:UIViewAnimationOptionCurveEaseInOut completion:completion];
}

-(void)openDrawerDirection:(ETDirection)direction animated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions)options completion:(void (^)(BOOL))completion{
    NSParameterAssert(direction != ETNoneDirection);
    
    UIViewController * sideDrawerViewController = [self drawerViewControllerForDirection:direction];
    CGRect visibleRect = CGRectIntersection(self.view.bounds,sideDrawerViewController.view.frame);
    BOOL drawerFullyCovered = (CGRectContainsRect(self.centerContainerView.frame, visibleRect) ||
                               CGRectIsNull(visibleRect));
    if(drawerFullyCovered)
    {
        [self prepareToPresentDrawer:direction animated:animated];
    }
    
    if(sideDrawerViewController)
    {
        CGRect newFrame;
        CGRect oldFrame = self.centerContainerView.frame;
        
        CGFloat distance = ABS(CGRectGetMinX(oldFrame)-newFrame.origin.x);
        NSTimeInterval duration = MAX(distance/ABS(velocity),ETDrawerMinimumAnimationDuration);
        
        if(direction == ETLeftDirection)
        {
            newFrame = self.centerContainerView.frame;
            newFrame.origin.x = self.maximumLeftDrawerWidth;
        }
        else if(direction == ETRightDirection)
        {
            newFrame = self.centerContainerView.frame;
            newFrame.origin.x = 0-self.maximumRightDrawerWidth;
        }
        else if(direction == ETDownDirection)
        {
            newFrame = self.centerContainerView.frame;
            newFrame.origin.y = 0-self.maximumBottomDrawerHeight;
            distance = ABS(CGRectGetMinY(self.centerContainerView.frame));
            duration = MAX(distance/ABS(ETDrawerDefaultAnimationVelocityY),ETDrawerMinimumAnimationDuration);
        }
        
        [UIView
         animateWithDuration:(animated?duration:0.0)
         delay:0.0
         options:options
         animations:^{
             [self.centerContainerView setFrame:newFrame];
             [self updateDrawerVisualStateForDrawerSide:direction percentVisible:1.0];
         }
         completion:^(BOOL finished) {
             //End the appearance transition if it already wasn't open.
             if(direction != self.openDirection)
             {
                 [sideDrawerViewController endAppearanceTransition];
             }
             [self setOpenDirection:direction];
             
             [self resetDrawerVisualStateForDrawerSide:direction];
             
             if(completion){
                 completion(finished);
             }
         }];
    }
}

@end











