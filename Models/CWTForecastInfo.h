//
//  CWTForecastInfo.h
//  cardWeather
//
//  Created by east on 14/12/3.
//  Copyright (c) 2014年 east. All rights reserved.
//

#import "Mantle.h"

@interface CWTForecastInfo : MTLModel<MTLJSONSerializing>

//f
@property (nonatomic, strong) NSString *wtDay;          //白天天气现象编号
@property (nonatomic, strong) NSString *wtNight;        //晚上天气现象编号
@property (nonatomic, strong) NSString *tempDay;        //白天天气温度(摄氏度)
@property (nonatomic, strong) NSString *tempNight;      //晚上天气温度(摄氏度)
@property (nonatomic, strong) NSString *wdDay;          //白天风向编号
@property (nonatomic, strong) NSString *wdNight;        //晚上风向编号
@property (nonatomic, strong) NSString *wsDay;          //白天风力编号
@property (nonatomic, strong) NSString *wsNight;        //晚上风力编号
@property (nonatomic, strong) NSString *sunTime;        //日出日落时间(中间用|分割)

//
- (NSString *)wtDayName;

- (NSString *)wtNightName;

- (NSString *)wdDayName;

- (NSString *)wdNightName;

- (NSString *)wsDayName;

- (NSString *)wsNightName;

@end
