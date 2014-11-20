//
//  CWTHTTPClient.m
//  cardWeather
//
//  Created by April on 11/21/14.
//  Copyright (c) 2014 east. All rights reserved.
//

#import "CWTHTTPClient.h"

#define CWTCLIENT [CWTHTTPClient sharedClient]

#define CWTPOST(path,params,sblock,eblock) \
[CWTCLIENT POST:path \
parameters:params \
success:^(NSURLSessionDataTask * task, id jsonobjects) { \
if (sblock){ \
sblock(jsonobjects); \
}}\
failure:^(NSURLSessionDataTask *task, NSError *error) {\
NSLog(@"Error: %@", error);\
if (eblock){\
eblock([error localizedDescription]);\
}}];

#define CWTGET(path,params,sblock,eblock) \
[CWTCLIENT GET:path \
parameters:params \
success:^(NSURLSessionDataTask* task, id jsonobjects) {  \
if (sblock){ \
sblock(obj); \
}}\
failure:^(NSURLSessionDataTask* task, NSError *error) {\
NSLog(@"Error: %@", error);\
if (eblock){\
eblock([error localizedDescription]);\
}}];

static NSString *const CWTServer = @"";

@interface CWTHTTPClient()
{
}
@end

@implementation CWTHTTPClient

+ (id)sharedClient
{
    static CWTHTTPClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate = 0;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:CWTServer]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self)
    {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    self.parameterEncoding = AFJSONParameterEncoding;
    //超时设置
    self.fTimeout = AFNETWORKTIMEOUT;
    
    return self;
}

@end
