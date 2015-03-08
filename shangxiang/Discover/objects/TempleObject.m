//
//  TempleObject.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/15.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "TempleObject.h"

@implementation TempleObject

- (instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
        self.attacheId = [dic stringForKey:@"attacheid" withDefault:@""];
        self.attacheName = [dic stringForKey:@"attachename" withDefault:@""];
        self.buddhistName = [dic stringForKey:@"buddhistname" withDefault:@""];
        self.attacheBigUrl = [dic stringForKey:@"headface" withDefault:@""];
        self.attacheSmallUrl = [dic stringForKey:@"tmb_headface" withDefault:@""];
        self.templeBigUrl = [dic stringForKey:@"pic_path" withDefault:@""];
        self.templeSmallUrl = [dic stringForKey:@"pic_tmb_path" withDefault:@""];
        self.templeProvince = [dic stringForKey:@"province" withDefault:@""];
        self.recommendSort = [dic intForKey:@"recommendsort" withDefault:0];
        self.templeId = [dic stringForKey:@"templeid" withDefault:@""];
        self.templeName = [dic stringForKey:@"templename" withDefault:@""];
    }
    return self;
}

@end
