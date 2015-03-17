//
//  MyRequestManager.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/23.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRequestManager : NSObject

//获取订单列表
+(BaseRequest*)getMemerOrderList:(NSString*)mid
                            also:(NSString*)also
                            page:(NSInteger)page
                       pageCount:(NSInteger)pageCount
                    successBlock: (RequestSuccessBlock)successBlock
                          failed:(RequestErrorBlock)errorBlock;

//意见反馈
+ (BaseRequest*)postFeedBackInfo:(NSString*)mid content:(NSString*)content
                    successBlock: (RequestSuccessBlock)successBlock
                          failed:(RequestErrorBlock)errorBlock;

//修改头像
+ (BaseRequest*)postUserImage:(NSString*)mid imageData:(NSData*)data
                 successBlock: (RequestSuccessBlock)successBlock
                       failed:(RequestErrorBlock)errorBlock;

//修改资料
+ (BaseRequest*)changUserInfo:(NSString*)mid nickName:(NSString*)nickName trueName:(NSString*)trueName area:(NSString*)area sex:(NSInteger)sex
                 successBlock: (RequestSuccessBlock)successBlock
                       failed:(RequestErrorBlock)errorBlock;

//发送资料
+ (BaseRequest*)sendMobileMessage:(NSString*)mobile
                     successBlock: (RequestSuccessBlock)successBlock
                           failed:(RequestErrorBlock)errorBlock;

//发送资料
+ (BaseRequest*)ResetChangeMobileMessage:(NSString*)mobile
                                password:(NSString*)password
                            successBlock: (RequestSuccessBlock)successBlock
                                  failed:(RequestErrorBlock)errorBlock;

//删除订单
+ (BaseRequest*)deleteOrder:(NSString*)oid successBlock: (RequestSuccessBlock)successBlock
                     failed:(RequestErrorBlock)errorBlock;

//获取城市列表
+ (BaseRequest*)getProvinceCitys: (RequestSuccessBlock)successBlock
                          failed:(RequestErrorBlock)errorBlock;

//获取通知
+ (BaseRequest*)getNotificationList: (RequestSuccessBlock)successBlock
                          failed:(RequestErrorBlock)errorBlock;

//获取微信支付token
+ (BaseRequest*)getWeixinAccessToken: (RequestSuccessBlock)successBlock
                              failed:(RequestErrorBlock)errorBlock;

@end
