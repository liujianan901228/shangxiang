//
//  LUtility.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LUtility : NSObject
+ (BOOL)isHigherIOS6;
+ (BOOL)isHigherIOS7;
+ (NSDictionary *)urlQueryInfo:(NSString *)query;
+ (NSString *)machineModel;
+ (NSString*)currentDevice;
+ (NSString*)getWishTitle:(WishType)wishType;
+ (WishType)getWishType:(NSString*)wishTitle;
+ (NSString*)getShowName;
+ (NSString*)getDisCoverShowName:(NSString*)nickName trueName:(NSString*)trueName;
/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//通过月  日获取佛历节日
+ (NSString*)getBuildListName:(NSInteger)month day:(NSInteger)day;
+ (NSString *)md5:(NSString *)input;

+ (NSString *)sha1:(NSString *)input;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSDictionary *)getIPAddresses;
@end
