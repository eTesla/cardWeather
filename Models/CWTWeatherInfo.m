//
//  CWTWeatherInfo.m
//  cardWeather
//
//  Created by east on 14/12/1.
//  Copyright (c) 2014年 east. All rights reserved.
//

#import "CWTWeatherInfo.h"

//:{"date":"20141201","cityName":"广州","areaID":"101280101","temp":"16℃","tempF":"60.8℉","wd":"北风","ws":"3级","sd":"61%","time":"15:35","sm":"暂无实况"}}

/*
+ (NSDictionary *)imageMap {
    static NSDictionary *_imageMap = nil;
    if (! _imageMap) {
        _imageMap = @{
                      @"01d" : @"weather-clear",
                      @"02d" : @"weather-few",
                      @"03d" : @"weather-few",
                      @"04d" : @"weather-broken",
                      @"09d" : @"weather-shower",
                      @"10d" : @"weather-rain",
                      @"11d" : @"weather-tstorm",
                      @"13d" : @"weather-snow",
                      @"50d" : @"weather-mist",
                      @"01n" : @"weather-moon",
                      @"02n" : @"weather-few-night",
                      @"03n" : @"weather-few-night",
                      @"04n" : @"weather-broken",
                      @"09n" : @"weather-shower",
                      @"10n" : @"weather-rain-night",
                      @"11n" : @"weather-tstorm",
                      @"13n" : @"weather-snow",
                      @"50n" : @"weather-mist",
                      };
    }
    return _imageMap;
}

- (NSString *)imageName {
    return [WXCondition imageMap][self.icon];
}
*/

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
