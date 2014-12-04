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
             @"wtDay": @"fa",
             @"wtNight": @"fb",
             @"tempDay": @"fc",
             @"tempNight": @"fd",
             @"wdDay": @"fe",
             @"wdNight": @"ff",
             @"wsDay": @"fg",
             @"wsNight": @"fh",
             @"sunTime": @"fi",
             };
}

- (NSString *)wtDayName {
    return [CWTWeatherMap weatherMap][self.wtDay];
}

- (NSString *)wtNightName {
    return [CWTWeatherMap weatherMap][self.wtNight];
}


- (NSString *)wdDayName {
    return [CWTWeatherMap windMap][self.wdNight];
}


- (NSString *)wdNightName {
    return [CWTWeatherMap windMap][self.wdNight];
}


- (NSString *)wsDayName {
    return [CWTWeatherMap windSpeedMap][self.wsNight];
}


- (NSString *)wsNightName {
    return [CWTWeatherMap windSpeedMap][self.wsNight];
}

@end
