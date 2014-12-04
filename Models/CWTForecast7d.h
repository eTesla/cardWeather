//
//  CWTForecast7d.h
//  cardWeather
//
//  Created by April on 12/3/14.
//  Copyright (c) 2014 east. All rights reserved.
//

#import "Mantle.h"

@interface CWTForecast7d : MTLModel<MTLJSONSerializing>

//c for cityinfo
@property (nonatomic, strong) NSString *areaID;         //城市id
@property (nonatomic, strong) NSString *cityName;       //城市
@property (nonatomic, strong) NSString *cityNameE;      //城市英文
@property (nonatomic, strong) NSString *city;           //市
@property (nonatomic, strong) NSString *cityE;          //市英文
@property (nonatomic, strong) NSString *pronvice;       //省
@property (nonatomic, strong) NSString *pronviceE;      //省英文
@property (nonatomic, strong) NSString *nation;         //国家
@property (nonatomic, strong) NSString *nationE;        //国家英文
@property (nonatomic, strong) NSString *cityLevel;      //城市级别
@property (nonatomic, strong) NSString *cityCode;       //城市区号
@property (nonatomic, strong) NSString *cityZCode;      //邮编
@property (nonatomic, strong) NSString *longitude;      //经度
@property (nonatomic, strong) NSString *latitude;       //纬度
@property (nonatomic, strong) NSString *altitude;       //海拔
@property (nonatomic, strong) NSString *radarNum;       //雷达站号

@property (nonatomic, strong) NSString *year;           //年份
@property (nonatomic, strong) NSString *month;          //月份
@property (nonatomic, strong) NSString *day;            //日
@property (nonatomic, strong) NSString *time;           //时间

@property (nonatomic, strong) NSArray *forecast7dData;

@end
