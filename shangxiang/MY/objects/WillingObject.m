//
//  WillingObject.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/23.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "WillingObject.h"

@implementation WillingObject

- (instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
        self.attacheName = [dic stringForKey:@"attachename" withDefault:@""];
        self.buddhaDate = [dic stringForKey:@"buddhadate" withDefault:@""];
        self.buddhistName = [dic stringForKey:@"buddhistname" withDefault:@""];
        self.orderId = [dic stringForKey:@"orderid" withDefault:@""];
        self.orderNumber = [dic stringForKey:@"ordernumber" withDefault:@""];
        self.retime = [dic stringForKey:@"retime" withDefault:@""];
        self.templeName = [dic stringForKey:@"templename" withDefault:@""];
        self.timeDiff = [dic intForKey:@"time_diff" withDefault:0];
        self.status = [dic stringForKey:@"status" withDefault:@""];
    }
    return self;
}

@end
