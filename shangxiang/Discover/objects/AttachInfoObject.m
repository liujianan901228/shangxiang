//
//  AttachInfoObject.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/17.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "AttachInfoObject.h"

@implementation AttachInfoObject

- (instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
        self.age = [dic stringForKey:@"age" withDefault:0];
        self.attacheId = [dic stringForKey:@"attacheid" withDefault:@""];
        self.attacheName = [dic stringForKey:@"attachename" withDefault:@""];
        self.buddhistName = [dic stringForKey:@"buddhistname" withDefault:@""];
        self.conversion = [dic stringForKey:@"conversion" withDefault:@""];
        self.attacheDescription = [dic stringForKey:@"description" withDefault:@""];
        self.headBigUrl = [dic stringForKey:@"headface" withDefault:@""];
        self.headSmallUrl = [dic stringForKey:@"tmb_headface" withDefault:@""];
        self.templeName = [dic stringForKey:@"templename" withDefault:@""];
    }
    return self;
}

@end
