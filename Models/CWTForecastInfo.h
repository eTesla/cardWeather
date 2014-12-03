//
//  CWTForecastInfo.h
//  cardWeather
//
//  Created by east on 14/12/3.
//  Copyright (c) 2014年 east. All rights reserved.
//

#import "Mantle.h"

@interface CWTForecastInfo : MTLModel<MTLJSONSerializing>

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

//f
@property (nonatomic, strong) NSString *date;           //预报发布时间
@property (nonatomic, strong) NSString *wtDay;          //白天天气现象编号
@property (nonatomic, strong) NSString *wtNight;        //晚上天气现象编号
@property (nonatomic, strong) NSString *tempDay;        //白天天气温度(摄氏度)
@property (nonatomic, strong) NSString *tempNight;      //晚上天气温度(摄氏度)
@property (nonatomic, strong) NSString *wdDay;          //白天风向编号
@property (nonatomic, strong) NSString *wdNight;        //晚上风向编号
@property (nonatomic, strong) NSString *wsDay;          //白天风力编号
@property (nonatomic, strong) NSString *wsNight;        //晚上风力编号
@property (nonatomic, strong) NSString *sunTime;        //日出日落时间(中间用|分割)


@end
