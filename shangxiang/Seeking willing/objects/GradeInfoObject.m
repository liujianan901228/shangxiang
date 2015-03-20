//
//  GradeInfoObject.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/18.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "GradeInfoObject.h"

@implementation GradeInfoObject

- (instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
        self.gradeName = [dic stringForKey:@"name" withDefault:@""];
        self.gradeDescription = [dic stringForKey:@"desc" withDefault:@""];
        self.gradePrice = [dic floatForKey:@"price" withDefault:0.00];
        self.gradeVal = [dic intForKey:@"val" withDefault:0];
    }
    return self;
}

@end
