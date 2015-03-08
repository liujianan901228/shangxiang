//
//  UserBirthdayObject.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface UserBirthdayObject : NSObject

@property (nonatomic, strong) NSNumber* day;
@property (nonatomic, strong) NSNumber* month;
@property (nonatomic, strong) NSNumber* year;

-(NSString *)transBirthDayToString;
@end
