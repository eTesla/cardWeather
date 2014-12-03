//
//  CWTWeatherMap.m
//  cardWeather
//
//  Created by east on 14/12/3.
//  Copyright (c) 2014年 east. All rights reserved.
//

#import "CWTWeatherMap.h"

@implementation CWTWeatherMap

+ (NSDictionary *)weatherMap
{
    static NSDictionary *_weatherMap = nil;
    if (! _weatherMap) {
        _weatherMap = @{
                        @"00" : @"WEATHER00",
                        @"01" : @"WEATHER01",
                        @"02" : @"WEATHER02",
                        @"03" : @"WEATHER03",
                        @"04" : @"WEATHER04",
                        @"05" : @"WEATHER05",
                        @"06" : @"WEATHER06",
                        @"07" : @"WEATHER07",
                        @"08" : @"WEATHER08",
                        @"09" : @"WEATHER09",
                        @"10" : @"WEATHER10",
                        @"11" : @"WEATHER11",
                        @"12" : @"WEATHER12",
                        @"13" : @"WEATHER13",
                        @"14" : @"WEATHER14",
                        @"15" : @"WEATHER15",
                        @"16" : @"WEATHER16",
                        @"17" : @"WEATHER17",
                        @"18" : @"WEATHER18",
                        @"19" : @"WEATHER19",
                        @"20" : @"WEATHER20",
                        @"21" : @"WEATHER21",
                        @"22" : @"WEATHER22",
                        @"23" : @"WEATHER23",
                        @"24" : @"WEATHER24",
                        @"25" : @"WEATHER25",
                        @"26" : @"WEATHER26",
                        @"27" : @"WEATHER27",
                        @"28" : @"WEATHER28",
                        @"29" : @"WEATHER29",
                        @"30" : @"WEATHER30",
                        @"31" : @"WEATHER31",
                        @"53" : @"WEATHER53",
                        @"99" : @"WEATHER99",
                      };
    }
    return _weatherMap;
}

+ (NSDictionary *)windMap
{
    static NSDictionary *_windMap = nil;
    if (! _windMap) {
        _windMap = @{
                        @"0" : @"WIND00",
                        @"1" : @"WIND01",
                        @"2" : @"WIND02",
                        @"3" : @"WIND03",
                        @"4" : @"WIND04",
                        @"5" : @"WIND05",
                        @"6" : @"WIND06",
                        @"7" : @"WIND07",
                        @"8" : @"WIND08",
                        @"9" : @"WIND09",
                        };
    }
    return _windMap;
}

+ (NSDictionary *)windSpeedMap
{
    static NSDictionary *_windSpeedMap = nil;
    if (! _windSpeedMap) {
        _windSpeedMap = @{
                     @"0" : @"WINDSPEED00",
                     @"1" : @"WINDSPEED01",
                     @"2" : @"WINDSPEED02",
                     @"3" : @"WINDSPEED03",
                     @"4" : @"WINDSPEED04",
                     @"5" : @"WINDSPEED05",
                     @"6" : @"WINDSPEED06",
                     @"7" : @"WINDSPEED07",
                     @"8" : @"WINDSPEED08",
                     @"9" : @"WINDSPEED09",
                     };
    }
    return _windSpeedMap;
}

@end
