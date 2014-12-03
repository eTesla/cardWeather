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

//YTdkYTZjZGMxNGE0MzczYjVjZTAzMmUzYjZmZGM3NjliY2YzY2VlOQ==
//http://open.weather.com.cn/data/?appid=e2814fa605d9cf08&areaid=101010100&date=201411252341&type=index_f
//http://open.weather.com.cn/data/?areaid=101010100&type=index_f&date=201411252341&appid=e2814fa605d9cf08
//api.openweathermap.org/data/2.5/weather?id=2172797
//static NSString *const CWTServer = @"http://api.openweathermap.org/data/2.5/";
static NSString *const CWTServer = @"http://m.weather.com.cn/";
static NSString *const CWTServer_Open = @"http://open.weather.com.cn/";
static NSString *const openWeatherAppIdParams = @"e2814f";
static NSString *const openWeatherAppId = @"e2814fa605d9cf08";
static NSString *const openWeatherPrivateKey = @"8be0e2_SmartWeatherAPI_3aa54e7";

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
 * 查询天气实时接口
 *
 * @param aAreaId  区域 ID
 * @param sblock   数据发送成功的block
 * @param eblock   数据发送失败的block
 */

+ (void)getWeatherInfoWithAreaId:(NSString*)aAreaId
                    successBlock: (void (^)(id dict))sblock
                       erroBlock: (void (^)(NSString* errorMsg))eblock
{
    CWTCLIENT.baseURL = [NSURL URLWithString:CWTServer];
    NSString *path = [NSString stringWithFormat:@"ks/%@.html",aAreaId];
    CWTGET(path, nil, sblock, eblock);
}

/**
 * 查询7天天气预报接口
 *
 * @param aAreaId  区域 ID
 * @param sblock   数据发送成功的block
 * @param eblock   数据发送失败的block
 */

+ (void)getForecast7dWithAreaId:(NSString*)aAreaId
                    successBlock: (void (^)(id dict))sblock
                       erroBlock: (void (^)(NSString* errorMsg))eblock
{
    CWTCLIENT.baseURL = [NSURL URLWithString:CWTServer_Open];
    NSString *path = [NSString stringWithFormat:@"data/forecast/%@.html",aAreaId];
    CWTGET(path, nil, sblock, eblock);
}

/**
 * 查询24小时天气预报接口
 *
 * @param aAreaId  区域 ID
 * @param sblock   数据发送成功的block
 * @param eblock   数据发送失败的block
 */

+ (void)getForecast24hWithAreaId:(NSString*)aAreaId
                   successBlock: (void (^)(id dict))sblock
                      erroBlock: (void (^)(NSString* errorMsg))eblock
{
    CWTCLIENT.baseURL = [NSURL URLWithString:CWTServer];
    NSString *path = [NSString stringWithFormat:@"mpub/hours/%@.html",aAreaId];
    CWTGET(path, nil, sblock, eblock);
}

/**
 * 查询天气指数接口
 *
 * @param aAreaId  区域 ID
 * @param sblock   数据发送成功的block
 * @param eblock   数据发送失败的block
 */

+ (void)getWeatherIndexWithAreaId:(NSString*)aAreaId
                    successBlock: (void (^)(id dict))sblock
                       erroBlock: (void (^)(NSString* errorMsg))eblock
{
    CWTCLIENT.baseURL = [NSURL URLWithString:CWTServer_Open];
    NSString *path = [NSString stringWithFormat:@"data/index/%@.html",aAreaId];
    CWTGET(path, nil, sblock, eblock);
}


@end





