//
//  CWTForecast24h.h
//  cardWeather
//
//  Created by April on 12/3/14.
//  Copyright (c) 2014 east. All rights reserved.
//

#import "Mantle.h"

#pragma mark - CWTForecast24hInfo
@interface CWTForecast24hInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *weather;        //天气现象编号
@property (nonatomic, strong) NSString *tempC;          //天气温度(摄氏度)
@property (nonatomic, strong) NSString *wind;           //风向编号
@property (nonatomic, strong) NSString *windSpeed;      //风力编号
@property (nonatomic, strong) NSString *humidity;       //空气湿度
@property (nonatomic, strong) NSString *year;           //年份
@property (nonatomic, strong) NSString *month;          //月份
@property (nonatomic, strong) NSString *day;            //日
@property (nonatomic, strong) NSString *hour;           //小时
@property (nonatomic, strong) NSString *minute;         //分钟

@end


#pragma mark - CWTForecast24h
@interface CWTForecast24h : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSArray *forecastData;

@end
