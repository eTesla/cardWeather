//
//  NSString+HMACSHA1.h
//  cardWeather
//
//  Created by April on 11/25/14.
//  Copyright (c) 2014 east. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HMACSHA1)

- (NSString*)hmacsha1WithKey:(NSString *)secret;
- (NSString*)hmacsha256WithKey:(NSString *)secret;

@end
