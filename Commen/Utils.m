//
//  Utils.m
//  cardWeather
//
//  Created by April on 11/25/14.
//  Copyright (c) 2014 east. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString*)generateURIWithURL:(NSString*)url Dictionary:(NSDictionary*)dict
{
    NSParameterAssert(url);
    NSParameterAssert(dict);
    
    NSMutableString *uri = [NSMutableString stringWithString:url];
    
    for (NSString* key in [dict allKeys])
    {
        [uri appendFormat:@"&%@=%@", key, [dict objectForKey:key]];
    }
    
    NSRange range = [uri rangeOfString:@"&"];
    [uri replaceCharactersInRange:range withString:@"?"];
    
    return uri;
}

@end
