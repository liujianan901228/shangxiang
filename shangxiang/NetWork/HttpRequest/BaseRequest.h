//
//  BaseRequest.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "SVHTTPRequest.h"
#import "ExError.h"

// Relase
#define DefaultBaseAddress  @"http://218.244.131.126:812/api/app/"

typedef void (^ RequestComplete)(NSInteger errorNum, id info, ExError *errorMsg);

typedef void(^RequestSuccessBlock)(id obj);
typedef void(^RequestErrorBlock)(id error);

typedef enum {
    EHTTPGet = 1<<0,
    EHTTPPOST = 1<<1,
    EHTTPKeepCookie = 1<<2,
    EHTTPNeedCookie = 1<<3,
    EHTTPLOAD = 1<<4,
}RequestType;

@interface RequestHelper : NSObject
@property(nonatomic,copy)NSString* cookie;
@property(nonatomic,copy)NSString* apiUrl;
@property(nonatomic,copy)NSString* captchaUrl;
+(RequestHelper*)shareInstance;
-(void)cookieClean;

@end

@interface BaseRequest : SVHTTPRequest

@property(nonatomic)BOOL shouldKeepCookie;

-(instancetype)initWithAddress:(NSString*)baseAddress
                    parameters:(NSDictionary*)params
                   RequestType:(SVHTTPRequestMethod)requestType
                 completeBlock:(RequestComplete)completeBlock;

+(id)sendGetRequestWithMethod:(NSString*)method
                   parameters:(NSDictionary*)params
                CompleteBlock:(RequestComplete)completeBlock;

+(id)sendPostRequestWithMethod:(NSString*)method
                    parameters:(NSDictionary*)params
                 CompleteBlock:(RequestComplete)completeBlock;

+(id)sendGetOtherUrl:(NSString*)requestUrl
          parameters:(NSDictionary*)params
       CompleteBlock:(RequestComplete)completeBlock;//获取非本程序url 例如微博微信。。。。

-(void)run;

@end
