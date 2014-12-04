//
//  CWTForecast24h.m
//  cardWeather
//
//  Created by April on 12/3/14.
//  Copyright (c) 2014 east. All rights reserved.
//

#import "CWTForecast24h.h"
#import "CWTWeatherMap.h"

#pragma mark - CWTForecast24hInfo
@implementation CWTForecast24hInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"weather": @"ja",
             @"tempC": @"jb",
             @"wind": @"jc",
             @"windSpeed": @"jd",
             @"humidity": @"je",
             @"year": @"jf",
             @"month": @"jf",
             @"day": @"jf",
             @"hour": @"jf",
             @"minute": @"jf",
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

+ (NSValueTransformer *)hourJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSString *str)
            {
                return [str substringWithRange:NSMakeRange(8, 2)];
            }];
}

+ (NSValueTransformer *)minuteJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSString *str)
            {
                return [str substringWithRange:NSMakeRange(10, 2)];
            }];
}

- (NSString *)wtName {
    return [CWTWeatherMap weatherMap][self.tempC];
}

- (NSString *)wdName {
    return [CWTWeatherMap windMap][self.wind];
}

- (NSString *)wsName {
    return [CWTWeatherMap windSpeedMap][self.windSpeed];
}

@end


#pragma mark - CWTForecast24h
@implementation CWTForecast24h

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"forecastData": @"jh",
             };
}

+ (NSValueTransformer *)forecastDataJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSArray *array)
            {
                NSArray *allData = [MTLJSONAdapter modelsOfClass:[CWTForecast24hInfo class] fromJSONArray:array error:nil];
                return allData;
                
            }];
}

@end
