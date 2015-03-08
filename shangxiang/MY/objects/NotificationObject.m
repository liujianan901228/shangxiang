//
//  NotificationObject.m
//  shangxiang
//
//  Created by limingchen on 15/2/9.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "NotificationObject.h"

@implementation NotificationObject

- (instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
        self.notifyId = [dic stringForKey:@"id" withDefault:@""];
        self.time = [dic stringForKey:@"cn_retime" withDefault:@""];
        self.title = [dic stringForKey:@"title" withDefault:@""];
    }
    return self;
}

@end
