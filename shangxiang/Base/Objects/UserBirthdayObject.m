//
//  UserBirthdayObject.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//


#import "UserBirthdayObject.h"

@implementation UserBirthdayObject

- (id) initWithDictionary:(NSDictionary *)dict {
    self = [self init];
    if (self) {
        [self setValueFromDictionary:dict];
    }
    return  self;
}

- (void) setValueFromDictionary:(NSDictionary *)dict {

    self.day = [dict valueForKey:@"day"];
    if ([self.day intValue] == 0) {
        self.day = [NSNumber numberWithInt:1];
    }
    self.month = [dict valueForKey:@"month"];
    if ([self.month intValue] <= 0) {
        self.month = [NSNumber numberWithInt:1];
    }
    self.year = [dict valueForKey:@"year"];
}
-(NSString *)transBirthDayToString{
    int year =[self.year intValue];
    return [NSString stringWithFormat:@"%.4d-%.2d-%.2d",year,[self.month intValue],[self.day intValue]];
}

@end
