//
//  CWTWeatherInfo.h
//  cardWeather
//
//  Created by east on 14/12/1.
//  Copyright (c) 2014年 east. All rights reserved.
//

#import "Mantle.h"

@interface CWTWeatherInfo : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *city;           //城市
@property (nonatomic, strong) NSString *areaID;         //城市id
@property (nonatomic, strong) NSString *tempC;          //温度c
@property (nonatomic, strong) NSString *tempF;          //温度f
@property (nonatomic, strong) NSString *wind;           //风向
@property (nonatomic, strong) NSString *windSpeed;      //风力大小
@property (nonatomic, strong) NSString *humidity;       //湿度
@property (nonatomic, strong) NSString *year;           //年份
@property (nonatomic, strong) NSString *month;          //月份
@property (nonatomic, strong) NSString *day;            //日
@property (nonatomic, strong) NSString *time;           //时间

@end
