//
//  OrderObject.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/13.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "OrderObject.h"

@implementation OrderObject

- (instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
        self.orderId = [dic stringForKey:@"orderid" withDefault:@""];
        self.orderLongId = [dic stringForKey:@"ordernumber" withDefault:@""];
        self.wishType = [dic stringForKey:@"wishtype" withDefault:@""];
        self.tid = [dic stringForKey:@"tid" withDefault:@""];
        self.alsoWish = [dic stringForKey:@"alsowish" withDefault:@""];
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
        self.bleuser = [dic stringForKey:@"bleuser" withDefault:@""];
        
        if(!USEROPERATIONHELP.isLogin)
        {
            self.isBelss = NO;
        }
        else
        {
            if(self.bleuser && self.bleuser.length > 0 && ![self.bleuser isEqualToString:@"0"]) self.isBelss = YES;
        }
    }
    return self;
}

@end
