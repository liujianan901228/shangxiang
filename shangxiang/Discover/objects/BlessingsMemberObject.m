//
//  BlessingsMemberObject.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/22.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BlessingsMemberObject.h"

@implementation BlessingsMemberObject

- (instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
        self.retime = [dic stringForKey:@"cn_retime" withDefault:@""];
        self.timeDiff = [dic intForKey:@"time_diff" withDefault:0];
        self.nickName = [dic stringForKey:@"nickname" withDefault:@""];
        self.trueName = [dic stringForKey:@"truename" withDefault:@""];
        self.largeUrl = [dic stringForKey:@"headface" withDefault:@""];
        self.thumbUrl = [dic stringForKey:@"tmb_headface" withDefault:@""];
    }
    return self;
}

@end
