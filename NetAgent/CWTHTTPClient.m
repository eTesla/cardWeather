//
//  CWTHTTPClient.m
//  cardWeather
//
//  Created by April on 11/21/14.
//  Copyright (c) 2014 east. All rights reserved.
//

#import "CWTHTTPClient.h"
#import "NSString+HMACSHA1.h"
#import "Utils.h"

static NSString * const openweatherAPPKey = @"7fb6473ef172655f1af22bdec4a40e85";

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
sblock(jsonobjects); \
}}\
failure:^(NSURLSessionDataTask* task, NSError *error) {\
NSLog(@"Error: %@", error);\
if (eblock){\
eblock([error localizedDescription]);\
}}];

//api.openweathermap.org/data/2.5/weather?id=2172797
static NSString *const CWTServer = @"http://api.openweathermap.org/data/2.5/";
//static NSString *const CWTServer = @"http://open.weather.com.cn/data/";
static NSString *const openWeatherAppIdParams = @"e2814f";
static NSString *const openWeatherAppId = @"e2814fa605d9cf08";
static NSString *const openWeatherPrivateKey = @"8be0e2_SmartWeatherAPI_3aa";

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
    
    return self;
}


/**
 * 查询天气接口
 *
 * @param aAreaId  区域 ID
 * @param aType    数据类型
 * @param sblock   数据发送成功的block
 * @param eblock   数据发送失败的block
 */

+ (void)getWeatherInfoWithAreaId:(NSString*)aAreaId
                            type:(NSString*)aType
                            date:(NSString*)aData
                    successBlock: (void (^)(id dict))sblock
                       erroBlock: (void (^)(NSString* errorMsg))eblock
{
    /*
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"101010100" forKey: @"areaid"];
    [params setObject:@"forecast_f" forKey: @"type"];
    [params setObject:@"201411252341" forKey: @"date"];
    [params setObject:openWeatherAppId forKey: @"appid"];
    
    NSString *urikey = [Utils generateURIWithURL:CWTServer Dictionary:params];
    urikey = [urikey hmacsha1WithKey:openWeatherPrivateKey];
    
    [params removeObjectForKey:@"appid"];
    [params setObject:openWeatherAppIdParams forKey: @"appid"];
    [params setObject:urikey forKey: @"key"];
     */
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2172797" forKey: @"id"];
    
    
    
    CWTGET(@"weather",params,sblock,eblock);
}

@end





