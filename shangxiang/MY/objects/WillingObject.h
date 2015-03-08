//
//  WillingObject.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/23.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WillingObject : NSObject

@property (nonatomic, copy) NSString* attacheName;//法师名字
@property (nonatomic, copy) NSString* buddhaDate;//日期
@property (nonatomic, copy) NSString* buddhistName;
@property (nonatomic, copy) NSString* orderId;
@property (nonatomic, copy) NSString* orderNumber;
@property (nonatomic, copy) NSString* retime;
@property (nonatomic, copy) NSString* templeName;
@property (nonatomic, assign) NSInteger timeDiff;
@property (nonatomic, copy) NSString* status;//订单状态

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
