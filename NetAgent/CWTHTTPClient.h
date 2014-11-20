//
//  CWTHTTPClient.h
//  cardWeather
//
//  Created by April on 11/21/14.
//  Copyright (c) 2014 east. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface CWTHTTPClient : AFHTTPSessionManager

+ (CWTHTTPClient *)sharedClient;

@end
