//
//  AppUser.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUser : NSObject
@property(nonatomic,copy) NSString* userName;//memberName
@property(nonatomic,copy) NSString* userId;//memberId
@property(nonatomic,copy) NSString* headUrl;
@property(nonatomic,copy) NSString* headBigUrl;
@property(nonatomic,copy) NSString* nickName;
@property(nonatomic,copy) NSString* trueName;
@property(nonatomic,copy) NSString* token;
@property(nonatomic,copy) NSString* secretKey;
@property(nonatomic)BOOL isLogined;
@property(nonatomic)NSInteger gender;
@property(nonatomic,copy)NSString* area;
@property(nonatomic, assign) NSInteger receivedBlessings;//收到加持数量
@property(nonatomic, assign) NSInteger doBlessings;//我的加持数量
@property(nonatomic, copy) NSString* mobile;
@property(nonatomic, copy) NSString* jregid;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
