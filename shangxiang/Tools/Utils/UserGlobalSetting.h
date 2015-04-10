//
//  UserGlobalSetting.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserGlobalSetting : NSObject

//设置全局的用户
+ (void)setCurrentUser:(AppUser*)user;

//获取全局的用户
+ (AppUser*)getCurrentUser;

//>是否是第一次打开
+(BOOL)isFirstOpenApp;

//>设置第一次打开
+(void)setFirstOpenApp;

@end
