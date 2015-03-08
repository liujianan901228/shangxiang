//
//  UserGlobalSetting.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "UserGlobalSetting.h"

#define GlobalCurrentUser @"GlobalCurrentUser"//全局用户

@implementation UserGlobalSetting

//设置全局的用户
+ (void)setCurrentUser:(AppUser*)user
{
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:user];
    if(archiveData)
    {
        [[NSUserDefaults standardUserDefaults] setObject:archiveData forKey:GlobalCurrentUser];
        [[NSUserDefaults standardUserDefaults] synchronize];//序列化一下
    }
}

//获取全局的用户
+ (AppUser*)getCurrentUser
{
    NSData *encodeData = [[NSUserDefaults standardUserDefaults] objectForKey:GlobalCurrentUser];
    if(encodeData)
    {
        AppUser* user = [NSKeyedUnarchiver unarchiveObjectWithData: encodeData];
        return user;
    }
    return nil;
}

@end
