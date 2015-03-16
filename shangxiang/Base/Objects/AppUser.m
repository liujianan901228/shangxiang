//
//  AppUser.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "AppUser.h"
#import "APService.h"

@implementation AppUser


- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.headUrl forKey:@"headUrl"];
    [aCoder encodeObject:self.headBigUrl forKey:@"headBigUrl"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.secretKey forKey:@"secretKey"];
    [aCoder encodeObject:self.trueName forKey:@"trueName"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isLogined] forKey:@"isLogined"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.gender] forKey:@"gender"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.area forKey:@"area"];
    [aCoder encodeObject:@(self.receivedBlessings) forKey:@"receivedBlessings"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.jregid forKey:@"jregid"];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [self init])
    {
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.headUrl = [aDecoder decodeObjectForKey:@"headUrl"];
        self.headBigUrl = [aDecoder decodeObjectForKey:@"headBigUrl"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.secretKey = [aDecoder decodeObjectForKey:@"secretKey"];
        self.isLogined = [[aDecoder decodeObjectForKey:@"isLogined"] boolValue];
        self.gender = [[aDecoder decodeObjectForKey:@"gender"] integerValue];
        self.trueName = [aDecoder decodeObjectForKey:@"trueName"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.area = [aDecoder decodeObjectForKey:@"area"];
        self.doBlessings = [[aDecoder decodeObjectForKey:@"receivedBlessings"] integerValue];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.jregid = [aDecoder decodeObjectForKey:@"jregid"];
    }
    return self;
}


- (instancetype)initWithDic:(NSDictionary*)dic
{
    if(self = [super init])
    {
        self.area = [dic stringForKey:@"area" withDefault:@""];
        self.headUrl = [dic stringForKey:@"tmb_headface" withDefault:@""];
        self.headBigUrl = [dic stringForKey:@"headface" withDefault:@""];
        self.userId = [dic stringForKey:@"memberid" withDefault:@""];
        self.userName = [dic stringForKey:@"membername" withDefault:@""];
        self.nickName = [dic stringForKey:@"nickname" withDefault:@""];
        self.gender = [dic intForKey:@"sex" withDefault:0];
        self.trueName = [dic stringForKey:@"truename" withDefault:@""];
        self.receivedBlessings = [dic intForKey:@"received_blessings" withDefault:0];
        self.doBlessings = [dic intForKey:@"do_blessings" withDefault:0];
        self.mobile = [dic stringForKey:@"mobile" withDefault:@""];
        self.jregid = [dic stringForKey:@"jpushregid" withDefault:@""];
    }
    return self;
}

- (void)setJregid:(NSString *)jregid
{
    _jregid = jregid;
    if(USEROPERATIONHELP.currentUser && USEROPERATIONHELP.currentUser.isLogined && _jregid && _jregid.length > 0)
    {
        [APService setTags:nil alias:_jregid callbackSelector:nil object:nil];
    }
    else
    {
        [APService setTags:nil alias:nil callbackSelector:nil object:nil];
    }
}

@end
