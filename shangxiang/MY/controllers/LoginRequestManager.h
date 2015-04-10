//
//  LoginRequestManager.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/11.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginRequestManager : NSObject

//登录接口
+(BaseRequest*)postLogin:(NSString*)mobile andPassword:(NSString*)password success:(RequestSuccessBlock)successBlock
                  failed:(RequestErrorBlock)errorBlock;

//注册
+(BaseRequest*)postRegister:(NSString*)mobile andPassword:(NSString*)password success:(RequestSuccessBlock)successBlock
                     failed:(RequestErrorBlock)errorBlock;

//获取用户信息
+(BaseRequest*)sendGetUserInfo:(NSString*)userId success:(RequestSuccessBlock)successBlock
                        failed:(RequestErrorBlock)errorBlock;

//获取微博用户信息
+(BaseRequest*)sendGetWeiboUserInfo:(NSString*)userId token:(NSString*)token success:(RequestSuccessBlock)successBlock
                             failed:(RequestErrorBlock)errorBlock;

//获取微信token
+(BaseRequest*)sendGetWeiXinToken:(NSString*)code success:(RequestSuccessBlock)successBlock
                           failed:(RequestErrorBlock)errorBlock;


//获取微信userInfo
+(BaseRequest*)sendGetWeiXinInfo:(NSString*)token openId:(NSString*)openId success:(RequestSuccessBlock)successBlock
                          failed:(RequestErrorBlock)errorBlock;

//第三方登陆
+(BaseRequest*)sendThirdLogin:(NSString*)token name:(NSString*)name regtype:(NSString*)regtype headUrl:(NSString*)headUrl nickName:(NSString*)nickName success:(RequestSuccessBlock)successBlock
                       failed:(RequestErrorBlock)errorBlock;

//判断是否允许第三方登陆
+(BaseRequest*)sendGetAllowThird:(RequestSuccessBlock)successBlock
                          failed:(RequestErrorBlock)errorBlock;

@end
