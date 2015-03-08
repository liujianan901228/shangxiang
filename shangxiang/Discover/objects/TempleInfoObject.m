//
//  TempleInfoObject.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/16.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "TempleInfoObject.h"
#import "TemplePictureObject.h"

@implementation TempleInfoObject

- (instancetype)init
{
    if(self = [super init])
    {
        _images = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [self init])
    {
        self.templeId = [dic stringForKey:@"templeid" withDefault:@""];
        self.templeName = [dic stringForKey:@"templename" withDefault:@""];
        self.templeProvince = [dic stringForKey:@"province" withDefault:@""];
        self.templeBuildTime = [dic stringForKey:@"buildtime" withDefault:@""];
        self.orderCount = [dic intForKey:@"co_order" withDefault:0];
        self.templeDescription = [dic stringForKey:@"description" withDefault:@""];
        
        NSArray* array = [dic objectForKey:@"templepic"];
        
        if(array && array.count > 0)
        {
            for(NSDictionary* pictureDic in array)
            {
                TemplePictureObject* picTure = [[TemplePictureObject alloc] initWithDic:pictureDic];
                [_images addObject:picTure];
            }
        }
        
    }
    return self;
}

- (NSString*)getFirstBigUrl
{
    __block NSString* result = nil;
    [_images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TemplePictureObject* picTure = (TemplePictureObject*)obj;
        if(picTure.picBigUrl)
        {
            result = picTure.picBigUrl;
            *stop = YES;
        }
    }];
    return result;
}

- (NSString*)getFirstSmallUrl
{
    __block NSString* result = nil;
    [_images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TemplePictureObject* picTure = (TemplePictureObject*)obj;
        if(picTure.picSmallUrl)
        {
            result = picTure.picBigUrl;
            *stop = YES;
        }
    }];
    return result;
}

@end
