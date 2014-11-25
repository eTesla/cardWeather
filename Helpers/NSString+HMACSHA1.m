//
//  NSString+HMACSHA1.m
//  cardWeather
//
//  Created by April on 11/25/14.
//  Copyright (c) 2014 east. All rights reserved.
//

#import "NSString+HMACSHA1.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString(HMACSHA1)

- (NSString*)hmacsha1WithKey:(NSString *)secret
{
    const char *cKey = [secret cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *cHMACData = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    return([cHMACData base64EncodedStringWithOptions:0]);
}

-(NSString*)hmacsha256WithKey:(NSString *)secret
{
    const char *cKey = [secret cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *cHMACData = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA256_DIGEST_LENGTH];
    return([cHMACData base64EncodedStringWithOptions:0]);
}

@end
