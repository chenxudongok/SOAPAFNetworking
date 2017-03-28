//
//  SOAPAFNetworking.m
//  ZiYouNiao_Customer
//
//  Created by Dong on 2017/3/22.
//  Copyright © 2017年 zhanyun111. All rights reserved.
//

#import "SOAPAFNetworking.h"


#define XMLHEAD  @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header><CredentialSoapHeader xmlns=\"http://tempuri.org/\"><UserID></UserID><PassWord></PassWord></CredentialSoapHeader></soap:Header><soap:Body>"

#define XMLTAIL @"</soap:Body></soap:Envelope>"

#define HOST @"服务器地址"



@implementation SOAPAFNetworking


+ (SOAPAFNetworking *)sharedInstance
{
    static dispatch_once_t once;
    static SOAPAFNetworking *sharedInstance;
    dispatch_once(&once, ^{
        
        sharedInstance = [[SOAPAFNetworking alloc] init];
    });
    return sharedInstance;
}

//requestUrl 请求地址   methodName 方法名   requestParamer请求参数
-(void)SOAP:(NSString *)requestUrl methodName:(NSString *)methodName requestParamer:(NSString *)requestParame
    success:(void (^)(id responseObject))success
    failure:(void (^)(id error))failure
{
    requestParame = [NSString stringWithFormat:@"%@%@%@",XMLHEAD,requestParame,XMLTAIL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 30;
    // 返回数据
    //    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置响应数据类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml",@"application/xml",@"application/soap+xml",@"text/xml", nil]];
    // 设置请求头，也可以不设置
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%zd", requestParame.length] forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"http://tempuri.org/%@",methodName] forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setValue:HOST forHTTPHeaderField:@"Host"];
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return requestParame;
    }];
    //过滤特殊符号
    requestUrl = [requestUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager POST:requestUrl parameters:requestParame success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *XMLdic = [NSDictionary dictionaryWithXMLString:result];
        NSDictionary *dic = [XMLdic objectForKeyWithoutNull:@"soap:Body"];
        // 请求成功并且结果有值把结果传出去
        success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
}

@end
