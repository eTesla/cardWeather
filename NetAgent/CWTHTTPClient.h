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
                       erroBlock: (void (^)(NSString* errorMsg))eblock;

@end
