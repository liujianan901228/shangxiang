//
//  CalendarList.m
//  shangxiang
//
//  Created by 刘佳男 on 15/1/25.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "CalendarList.h"

@implementation CalendarList



- (instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
        self.calendarId = [dic stringForKey:@"id" withDefault:@""];
        self.relativesName = [dic stringForKey:@"relativesname" withDefault:@""];
        self.vtremindDate = [dic stringForKey:@"vtreminddate" withDefault:@""];
        self.remindTime = [dic stringForKey:@"remindtime" withDefault:@""];

    }
    return self;
}

@end
