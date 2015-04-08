//
//  BaseRequest.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseRequest.h"
#import "ExError.h"
#import "NSString+Ex.h"
#import "NSDictionary+NSDictionaryExt.h"

@implementation RequestHelper

+(RequestHelper*)shareInstance
{
    static dispatch_once_t onceToken;
    static id sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[RequestHelper alloc] init];
    });
    return sharedObject;
}


-(void)cookieClean
{
    self.cookie = nil;
}

@end


@interface BaseRequest()
@property(nonatomic,strong)NSMutableDictionary* queryParams;
@end

@implementation BaseRequest


-(instancetype)initWithAddress:(NSString*)baseAddress
                    parameters:(NSDictionary*)params
                   RequestType:(SVHTTPRequestMethod)requestType
                 completeBlock:(RequestComplete)completeBlock
{
    
    self = [super initWithAddress:baseAddress method:requestType parameters:(requestType == SVHTTPRequestMethodGET?nil:params) completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        if([response isKindOfClass:[NSDictionary class]])
        {
            id result = [response objectForKey:@"response"];
            if(result)
            {
                //自己网站
                if([[result objectForKey:@"code"] isEqualToString:@"succeed"])
                {
                    completeBlock(0,result,(ExError*)error);
                }
                else
                {
                    ExError* exError = [ExError errorWithCode:[result objectForKey:@"code"] errorMessage:[result objectForKey:@"msg"]];
                    
                    completeBlock(0,nil,exError);
                }
            }
            else
            {
                //微博获取用户信息
                if(!error)
                {
                    completeBlock(0,response,nil);
                }
                else
                {
                    ExError* exError = [ExError errorWithCode:@"0" errorMessage:@"登录失败"];
                    completeBlock(0,nil,exError);
                }
            }
        }
        else if([response isKindOfClass:[NSData class]])
        {
            NSDictionary* dictionary = [((NSData*)response) jsonValueDecoded];
            if(dictionary && dictionary.count > 0)
            {
                if([dictionary objectForKey:@"code"])
                {
                    //自己网站
                    if(dictionary && [[dictionary objectForKey:@"code"] isEqualToString:@"succeed"])
                    {
                        completeBlock(0,dictionary,(ExError*)error);
                    }
                    else
                    {
                        ExError* exError = [ExError errorWithCode:[dictionary objectForKey:@"code"] errorMessage:[dictionary objectForKey:@"msg"]];
                        completeBlock(0,nil,exError);
                    }
                }
                else
                {
                    completeBlock(0,dictionary,nil);
                }
            }
        }
    }];
    
    if(self)
    {
        self.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    }

    self.userAgent = [NSString stringWithFormat:@"device::%@|system::%@|version::%@",[ToolsHelper shareInstance].getCurrentSystem,[ToolsHelper shareInstance].getCurrentDevice,[UIApplication sharedApplication].appBuildVersion];
    NSLog(@"user Agent:%@", self.userAgent);
    
    return self;
}


+(id)sendGetRequestWithMethod:(NSString*)method
                   parameters:(NSDictionary*)params
                CompleteBlock:(RequestComplete)completeBlock
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@%@",DefaultBaseAddress,method];
    
    NSMutableDictionary* mutableParam = [NSMutableDictionary dictionary];

    if(mutableParam)
    {
        requestUrl = [NSString stringWithFormat:@"%@?%@",requestUrl,[params queryString]];
    }
    
    BaseRequest* request = [[BaseRequest alloc] initWithAddress:requestUrl parameters:nil RequestType:SVHTTPRequestMethodGET completeBlock:completeBlock];
    [request run];
    return request;
}

+(id)sendPostRequestWithMethod:(NSString*)method
                    parameters:(NSDictionary*)params
                 CompleteBlock:(RequestComplete)completeBlock
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@%@",DefaultBaseAddress,method];
    NSMutableDictionary* mutableParam = [NSMutableDictionary dictionary];
    if(mutableParam)
    {
        requestUrl = [NSString stringWithFormat:@"%@?%@",requestUrl,[params queryString]];
    }
    BaseRequest* request = [[BaseRequest alloc] initWithAddress:requestUrl parameters:params RequestType:SVHTTPRequestMethodPOST completeBlock:completeBlock];
    [request run];
    return request;
    
}


+(id)sendGetOtherUrl:(NSString*)requestUrl
                   parameters:(NSDictionary*)params
                CompleteBlock:(RequestComplete)completeBlock
{
    NSMutableDictionary* mutableParam = [NSMutableDictionary dictionary];
    if(params)
    {
        [mutableParam setValuesForKeysWithDictionary:params];
    }
    
    if(mutableParam)
    {
        requestUrl = [NSString stringWithFormat:@"%@?%@",requestUrl,[params queryString]];
    }
    
    BaseRequest* request = [[BaseRequest alloc] initWithAddress:requestUrl parameters:mutableParam RequestType:SVHTTPRequestMethodGET completeBlock:completeBlock];
    [request run];
    return request;
}

-(void)run
{
    [self start];
}


@end
