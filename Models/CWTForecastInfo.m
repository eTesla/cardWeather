//
//  CWTForecastInfo.m
//  cardWeather
//
//  Created by east on 14/12/3.
//  Copyright (c) 2014年 east. All rights reserved.
//

#import "CWTForecastInfo.h"
#import "CWTWeatherMap.h"

@implementation CWTForecastInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"areaID": @"c.c1",
             @"cityName": @"c.c2",
             @"cityNameE": @"c.c3",
             @"city": @"c.c4",
             @"cityE": @"c.c5",
             @"pronvice": @"c.c6",
             @"pronviceE": @"c.c7",
             @"nation": @"c.c8",
             @"nationE": @"c.c9",
             @"cityLevel": @"c.c10",
             @"cityCode": @"c.c11",
             @"cityZCode": @"c.c12",
             @"longitude": @"c.c13",
             @"latitude": @"c.c14",
             @"altitude": @"c.c15",
             @"radarNum": @"c.c16",
             @"year": @"f.f0",
             @"month": @"f.f0",
             @"day": @"f.f0",
             @"time": @"f.f0",
             @"wtDay": @"f.f1.fa",
             @"wtNight": @"f.f1.fb",
             @"tempDay": @"f.f1.fc",
             @"tempNight": @"f.f1.fd",
             @"wdDay": @"f.f1.fe",
             @"wdNight": @"f.f1.ff",
             @"wsDay": @"f.f1.fg",
             @"wsNight": @"f.f1.fh",
             @"sunTime": @"f.f1.fi",
             };
}


+ (NSValueTransformer *)yearJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSString *str)
            {
                return [str substringWithRange:NSMakeRange(0, 4)];
            }];
}

+ (NSValueTransformer *)monthJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSString *str)
            {
                return [str substringWithRange:NSMakeRange(4, 2)];
            }];
}

+ (NSValueTransformer *)dayJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSString *str)
            {
                return [str substringWithRange:NSMakeRange(6, 2)];
            }];
}

+ (NSValueTransformer *)timeJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSString *str)
            {
                return [NSString stringWithFormat:@"%@:%@", [str substringWithRange:NSMakeRange(8, 2)], [str substringWithRange:NSMakeRange(10, 2)]];
            }];
}

- (NSString *)wtDayName {
    return [CWTWeatherMap weatherMap][self.wtDay];
}

- (NSString *)wtNightName {
    return [CWTWeatherMap weatherMap][self.wtNight];
}


- (NSString *)wdDayName {
    return [CWTWeatherMap weatherMap][self.wdNight];
}


- (NSString *)wdNightName {
    return [CWTWeatherMap weatherMap][self.wdNight];
}


- (NSString *)wsDayName {
    return [CWTWeatherMap weatherMap][self.wsNight];
}


- (NSString *)wsNightName {
    return [CWTWeatherMap weatherMap][self.wsNight];
}

@end
