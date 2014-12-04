//
//  CWTForecast7d.m
//  cardWeather
//
//  Created by April on 12/3/14.
//  Copyright (c) 2014 east. All rights reserved.
//

#import "CWTForecast7d.h"
#import "CWTForecastInfo.h"

@implementation CWTForecast7d

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
             @"forecast7dData": @"f.f1",
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

+ (NSValueTransformer *)forecast7dDataJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSArray *array)
            {
                NSArray *allData = [MTLJSONAdapter modelsOfClass:[CWTForecastInfo class] fromJSONArray:array error:nil];
                return allData;
                
            }];
}

@end
