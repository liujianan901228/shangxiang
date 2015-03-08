//
//  UserOperationHelper.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppNavigator.h"
#import "AppUser.h"
#import "VersionUpdateObject.h"

@interface UserOperationHelper : NSObject
@property(nonatomic,strong)AppUser* currentUser;
@property(nonatomic,strong)AppNavigator* appNavigator;
@property(nonatomic,strong)VersionUpdateObject* versionUpdateObj;

+(instancetype)shareInstance;

- (BOOL)isLogin;

@end
