//
//  OrderInfoObject.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/31.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "OrderInfoObject.h"

@implementation OrderInfoObject


- (instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
        _images = [[NSMutableArray alloc] init];
        _alsoWish = [dic stringForKey:@"alsowish" withDefault:@""];
        _orderId = [dic stringForKey:@"orderid" withDefault:@""];
        _orderLongId = [dic stringForKey:@"ordernumber" withDefault:@""];
        _wishType = [dic stringForKey:@"wishtype" withDefault:@""];
        _tid = [dic stringForKey:@"tid" withDefault:@""];
        _retime = [dic intForKey:@"retime" withDefault:0];
        _wishName = [dic stringForKey:@"wishname" withDefault:@""];
        _wishText = [dic stringForKey:@"wishtext" withDefault:@""];
        _timeDiff = [dic intForKey:@"time_diff" withDefault:0];
        _nickName = [dic stringForKey:@"nickname" withDefault:@""];
        _trueName = [dic stringForKey:@"truename" withDefault:@""];
        _headUrl = [dic stringForKey:@"headface" withDefault:@""];
        _coBlessings = [dic intForKey:@"co_blessings" withDefault:0];
        _nameBelssings = [dic stringForKey:@"name_blessings" withDefault:@""];
        _templeName = [dic stringForKey:@"templename" withDefault:@""];
        _wishDate = [dic stringForKey:@"wishdate" withDefault:@""];
        _province = [dic stringForKey:@"province" withDefault:@""];
        _status = [dic stringForKey:@"status" withDefault:@""];
        _templeThumb = [dic stringForKey:@"templepic_path" withDefault:@""];
        _builddhistName = [dic stringForKey:@"buddhistname" withDefault:@""];
        _builddHistThumb = [dic stringForKey:@"attache_headface" withDefault:@""];
        _wishGrade = [dic stringForKey:@"wishgrade" withDefault:@""];
        _builddhistId = [dic stringForKey:@"aid" withDefault:@""];
        _expectBuddhadate = [dic stringForKey:@"expect_buddhadate" withDefault:@""];
        NSString*  hy_orderid = [dic stringForKey:@"hy_orderid" withDefault:@"0"];
        if([hy_orderid isEqualToString:@"0"])
        {
            self.isRedeem = NO;
        }
        else
        {
            self.isRedeem = YES;
        }
    }
    return self;
}

@end
