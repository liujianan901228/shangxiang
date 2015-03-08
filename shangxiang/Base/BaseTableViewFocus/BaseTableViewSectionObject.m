//
//  BaseSectionObject.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseTableViewSectionObject.h"

@implementation BaseTableViewSectionObject

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.items = [NSMutableArray array];
    }
    return self;
}

@end
