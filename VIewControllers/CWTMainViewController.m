//
//  CWTMainViewController.m
//  cardWeather
//
//  Created by east on 14/11/20.
//  Copyright (c) 2014年 east. All rights reserved.
//

#import <POP/POP.h>
#import "CWTMainViewController.h"
#import "CWTMenuButton.h"
#import "UIViewController+ETDrawerController.h"
#import "ETDrawerViewController.h"
#import "CWTHTTPClient.h"
#import "Mantle.h"
#import "CWTWeatherInfo.h"

@interface CWTMainViewController ()
{
    
}

@property (strong, nonatomic) IBOutlet UIView *weatherContainer;
@property (strong, nonatomic) IBOutlet UIImageView *weatherImgV;
@property (strong, nonatomic) IBOutlet UILabel *tempLabel;
@property (strong, nonatomic) IBOutlet CWTMenuButton *menuBtn;

- (IBAction)menuBtnClicked:(id)sender;

@end

@implementation CWTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak CWTMainViewController *weakself = self;
    [self.et_drawerController setGestureCompletionBlock:^(ETDrawerViewController *drawerController, UIGestureRecognizer * gesture) {
        [weakself.menuBtn touchUpInsideHandler:nil];
    }];
    
    [CWTHTTPClient getWeatherInfoWithAreaId:@"101280101"
                               successBlock:^(id object){
                                   NSLog(@"success!!");
                                   NSLog(@"response = %@", object);
                                   
                                   CWTWeatherInfo *weatherInfo = [MTLJSONAdapter modelOfClass:[CWTWeatherInfo class] fromJSONDictionary:object error:nil];
                               }
                                  erroBlock:^(NSString* error){
                                      
                                      NSLog(@"fail!!");
    }];
    
    [CWTHTTPClient getForecast7dWithAreaId:@"101280101"
                               successBlock:^(id object){
                                   NSLog(@"success!!");
                                   NSLog(@"response = %@", object);
                               }
                                  erroBlock:^(NSString* error){
                                      
                                      NSLog(@"fail!!");
                                  }];
    
    [CWTHTTPClient getForecast24hWithAreaId:@"101280101"
                               successBlock:^(id object){
                                   NSLog(@"success!!");
                                   NSLog(@"response = %@", object);
                               }
                                  erroBlock:^(NSString* error){
                                      
                                      NSLog(@"fail!!");
                                  }];
    
    [CWTHTTPClient getWeatherIndexWithAreaId:@"101280101"
                               successBlock:^(id object){
                                   NSLog(@"success!!");
                                   NSLog(@"response = %@", object);
                               }
                                  erroBlock:^(NSString* error){
                                      
                                      NSLog(@"fail!!");
                                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - getter/setter
/*
- (CWTMenuButton*)menuBtn
{
    if (!_menuBtn)
    {
        _menuBtn = [CWTMenuButton button];
        [_menuBtn addTarget:self action:@selector(menuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _menuBtn.tintColor = [UIColor whiteColor];
        _menuBtn.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _menuBtn;
}
 */

#pragma mark - Action

- (IBAction)menuBtnClicked:(id)sender;
{
    [self.et_drawerController toggleDrawerSide:ETRightDirection animated:YES completion:nil];
}

#pragma mark - layout UI
- (void)layoutSetup
{
    [self menuBtnLayout];
}

- (void)menuBtnLayout
{
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:[_menuBtn]-(35)-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_menuBtn)]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-(15)-[_menuBtn]"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_menuBtn)]];
}

@end
