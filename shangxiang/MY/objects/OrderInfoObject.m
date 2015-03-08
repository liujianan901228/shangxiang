//
//  OrderInfoObject.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/31.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "OrderInfoObject.h"

@implementation OrderInfoObject

- (instancetype)init
{
    if(self = [super init])
    {
        self.images = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [self init])
    {
        self.alsoWish = [dic stringForKey:@"alsowish" withDefault:@""];
        self.orderId = [dic stringForKey:@"orderid" withDefault:@""];
        self.orderLongId = [dic stringForKey:@"ordernumber" withDefault:@""];
        self.wishType = [dic stringForKey:@"wishtype" withDefault:@""];
        self.tid = [dic stringForKey:@"tid" withDefault:@""];
        self.retime = [dic intForKey:@"retime" withDefault:0];
        self.wishName = [dic stringForKey:@"wishname" withDefault:@""];
        self.wishText = [dic stringForKey:@"wishtext" withDefault:@""];
        self.timeDiff = [dic intForKey:@"time_diff" withDefault:0];
        self.nickName = [dic stringForKey:@"nickname" withDefault:@""];
        self.trueName = [dic stringForKey:@"truename" withDefault:@""];
        self.headUrl = [dic stringForKey:@"headface" withDefault:@""];
        self.coBlessings = [dic intForKey:@"co_blessings" withDefault:0];
        self.nameBelssings = [dic stringForKey:@"name_blessings" withDefault:@""];
        self.templeName = [dic stringForKey:@"templename" withDefault:@""];
        self.wishDate = [dic stringForKey:@"wishdate" withDefault:@""];
        self.province = [dic stringForKey:@"province" withDefault:@""];
        self.status = [dic stringForKey:@"status" withDefault:@""];
        self.templeThumb = [dic stringForKey:@"templepic_path" withDefault:@""];
        self.builddhistName = [dic stringForKey:@"buddhistname" withDefault:@""];
        self.builddHistThumb = [dic stringForKey:@"attache_headface" withDefault:@""];
        self.wishGrade = [dic stringForKey:@"wishgrade" withDefault:@""];
        self.builddhistId = [dic stringForKey:@"aid" withDefault:@""];
        self.expectBuddhadate = [dic stringForKey:@"expect_buddhadate" withDefault:@""];
    }
    return self;
}

@end
