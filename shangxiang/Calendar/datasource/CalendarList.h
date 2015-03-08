//
//  CalendarList.h
//  shangxiang
//
//  Created by 刘佳男 on 15/1/25.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarList : NSObject

@property (nonatomic, copy) NSString* calendarId;//生日ID
@property (nonatomic, copy) NSString* relativesName;//亲友姓名
@property (nonatomic, copy) NSString* vtremindDate;//生日日期
@property (nonatomic, copy) NSString* remindTime;//提醒间隔

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
