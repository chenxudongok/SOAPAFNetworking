//
//  SOAPAFNetworking.h
//  ZiYouNiao_Customer
//
//  Created by Dong on 2017/3/22.
//  Copyright © 2017年 zhanyun111. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOAPAFNetworking : NSObject


+ (SOAPAFNetworking *)sharedInstance;


//SOAP请求
//requestUrl 请求地址   methodName 方法名   requestParamer请求参数
-(void)SOAP:(NSString *)requestUrl methodName:(NSString *)methodName requestParamer:(NSString *)requestParame
    success:(void (^)(id responseObject))success
    failure:(void (^)(id error))failure;
@end
