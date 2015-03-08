//
//  UserOperationHelper.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "UserOperationHelper.h"
#import "AppNavigator.h"

@implementation UserOperationHelper
+(instancetype)shareInstance
{
    static UserOperationHelper    *userOperationHelper = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        userOperationHelper = [[UserOperationHelper alloc] init];
    });
    return userOperationHelper;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.appNavigator = [[AppNavigator alloc] init];
    }
    return self;
}


- (BOOL)isLogin
{
    if(self.currentUser && self.currentUser.userId && self.currentUser.isLogined)
    {
        return YES;
    }
    return NO;
}

@end
