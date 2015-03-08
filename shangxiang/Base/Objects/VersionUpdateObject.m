//
//  VersionUpdateObject.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "VersionUpdateObject.h"

@implementation VersionUpdateObject

-(id)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    if(self) {
        self.link = [dic stringForKey:@"link" withDefault:@""];
        self.lastVersion = [dic stringForKey:@"version" withDefault:@""];
        self.type = [dic intForKey:@"tactics" withDefault:0];
    }
    return self;
}
@end
