//
//  CWTWeatherInfo.m
//  cardWeather
//
//  Created by east on 14/12/1.
//  Copyright (c) 2014年 east. All rights reserved.
//

#import "CWTWeatherInfo.h"

//:{"date":"20141201","cityName":"广州","areaID":"101280101","temp":"16℃","tempF":"60.8℉","wd":"北风","ws":"3级","sd":"61%","time":"15:35","sm":"暂无实况"}}

@implementation CWTWeatherInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"year": @"sk_info.date",
             @"month": @"sk_info.date",
             @"day": @"sk_info.date",
             @"city": @"sk_info.cityName",
             @"areaID": @"sk_info.areaID",
             @"tempC": @"sk_info.temp",
             @"tempF": @"sk_info.tempF",
             @"wind": @"sk_info.wd",
             @"windSpeed": @"sk_info.ws",
             @"humidity": @"sk_info.sd",
             @"time": @"sk_info.time"
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

@end
