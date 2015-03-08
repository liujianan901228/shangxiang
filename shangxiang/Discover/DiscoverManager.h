//
//  DiscoverManager.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/13.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverManager : NSObject

//获取发现列表
+(BaseRequest*)getDiscoverList:(NSString*)tid
                    pageNumber:(NSInteger)pageNumber
                   numberCount:(NSInteger)numberCount
                         bless:(BelssType)blessType
                  successBlock:(RequestSuccessBlock)successBlock
                        failed:(RequestErrorBlock)errorBlock;

//获取寺庙列表
+(BaseRequest*)getTempleList:(RequestSuccessBlock)successBlock
                      failed:(RequestErrorBlock)errorBlock;


//获取发现详情
+(BaseRequest*)getOrderInfoByBlessNumber:(NSString*)oid
               successBlock: (RequestSuccessBlock)successBlock
                     failed:(RequestErrorBlock)errorBlock;

//获取寺庙列表
+(BaseRequest*)getTempleList:(NSInteger)wishType
                successBlock:(RequestSuccessBlock)successBlock
                      failed:(RequestErrorBlock)errorBlock;

//为某一条发现加持
+ (BaseRequest*)addBlessingsdo:(NSString*)orderId userId:(NSString*)userId successBlock: (RequestSuccessBlock)successBlock
                        failed:(RequestErrorBlock)errorBlock;


//获取订单详情
+(BaseRequest*)getOrderInfo:(NSString*)oid
               successBlock: (RequestSuccessBlock)successBlock
                     failed:(RequestErrorBlock)errorBlock;

@end
