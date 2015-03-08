//
//  TemplePictureObject.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/17.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "TemplePictureObject.h"

@implementation TemplePictureObject

- (instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
        self.picBigUrl = [dic stringForKey:@"pic_path" withDefault:@""];
        self.picSmallUrl = [dic stringForKey:@"pic_tmb_path" withDefault:@""];
    }
    return self;
}

@end
