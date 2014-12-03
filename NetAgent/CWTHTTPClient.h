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

#pragma mark - 天气接口


/**
 * 查询天气实时接口
 *
 * @param aAreaId  区域 ID
 * @param sblock   数据发送成功的block
 * @param eblock   数据发送失败的block
 */

+ (void)getWeatherInfoWithAreaId:(NSString*)aAreaId
                    successBlock: (void (^)(id dict))sblock
                       erroBlock: (void (^)(NSString* errorMsg))eblock;
/**
 * 查询7天天气预报接口
 *
 * @param aAreaId  区域 ID
 * @param sblock   数据发送成功的block
 * @param eblock   数据发送失败的block
 */

+ (void)getForecast7dWithAreaId:(NSString*)aAreaId
                   successBlock: (void (^)(id dict))sblock
                      erroBlock: (void (^)(NSString* errorMsg))eblock;

/**
 * 查询24小时天气预报接口
 *
 * @param aAreaId  区域 ID
 * @param sblock   数据发送成功的block
 * @param eblock   数据发送失败的block
 */

+ (void)getForecast24hWithAreaId:(NSString*)aAreaId
                    successBlock: (void (^)(id dict))sblock
                       erroBlock: (void (^)(NSString* errorMsg))eblock;

/**
 * 查询天气指数接口
 *
 * @param aAreaId  区域 ID
 * @param sblock   数据发送成功的block
 * @param eblock   数据发送失败的block
 */

+ (void)getWeatherIndexWithAreaId:(NSString*)aAreaId
                     successBlock: (void (^)(id dict))sblock
                        erroBlock: (void (^)(NSString* errorMsg))eblock;

@end
