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
#import "CWTForecast7d.h"
#import "CWTForecastInfo.h"
#import "Utils.h"

@interface CWTMainViewController ()
{
    
}

@property (weak, nonatomic) IBOutlet UIView *weatherContainer;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImgV;
@property (weak, nonatomic) IBOutlet CWTMenuButton *menuBtn;

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

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
    
    /*
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
                                   
                                   CWTForecast7d *fInfo = [MTLJSONAdapter modelOfClass:[CWTForecast7d class] fromJSONDictionary:object error:nil];
                                
                                   CWTForecastInfo *data = [fInfo.forecast7dData objectAtIndex:1];
                                   NSLog(@"wt = %@", NSLocalizedString([data wtDayName], ""));
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
    */
    
    
    UIColor *color1 = [UIColor colorWithRed:246.0f/255.0f green:194.0f/255.0f blue:93.0f/255.0f alpha:1.0f];
    UIColor *color2 = [UIColor colorWithRed:244.0f/255.0f green:172.0f/255.0f blue:58.0f/255.0f alpha:1.0f];
    
    NSArray *colorArray = [NSArray arrayWithObjects:color1, color2, nil];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imgV.image = [Utils gradientImageFromColors:colorArray andSize:self.view.frame.size ByType:upleftTolowRightGtype];
    [self.view addSubview:imgV];
    [self.view sendSubviewToBack:imgV];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTimeAndDate];
    [self getWeatherToday];
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

- (void)updateUIWithInfo:(CWTWeatherInfo*)weatherInfo
{
    NSString *tmp = nil;
    NSRange range = [weatherInfo.tempC rangeOfString:@"℃"];
    tmp = [weatherInfo.tempC substringToIndex:range.location];
    tmp = [NSString stringWithFormat:@"%@°",tmp];
    
    self.tempLabel.text = tmp;
    self.cityLabel.text = weatherInfo.city;
    
}

- (void)updateTimeAndDate
{
    NSDate *date = [NSDate date];
    
    NSLog(@"date:%@",date);
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit |
    
    NSMonthCalendarUnit |
    
    NSDayCalendarUnit |
    
    NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit |
    
    NSMinuteCalendarUnit |
    
    NSSecondCalendarUnit;
    
    //int week=0;week1是星期天,week7是星期六;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int month_ = [comps month];
    int day_ = [comps day];
    int hour_ = [comps hour];
    int minute_ = [comps minute];
    calendar = nil;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02d月%02d", month_, day_];
    self.dateLabel.text = [NSString stringWithFormat:@"%02d:%02d", hour_, minute_];

}

#pragma mark - net 

- (void)getWeatherToday
{
    [CWTHTTPClient getWeatherInfoWithAreaId:@"101280101"
                               successBlock:^(id object){
                                   NSLog(@"success!!");
                                   NSLog(@"response = %@", object);
                                
                                   CWTWeatherInfo *weatherInfo = [MTLJSONAdapter modelOfClass:[CWTWeatherInfo class] fromJSONDictionary:object error:nil];
                                   
                                   [self updateUIWithInfo:weatherInfo];
                               }
                                  erroBlock:^(NSString* error){
                                      
                                      NSLog(@"fail!!");
                                  }];
}


@end
