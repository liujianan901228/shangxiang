//
//  CalendarDataSource.h
//  shangxiang
//
//  Created by 刘佳男 on 15/1/25.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "CalendarList.h"

@interface CalendarDataSource : NSObject<UIAlertViewDelegate>

//获取佛教节日
+(BaseRequest*)getLunarFestival:(NSInteger)month
                        WithMid:(NSInteger)mid
                        success:(RequestSuccessBlock)successBlock
                         failed:(RequestErrorBlock)errorBlock;

//获取佛历背景
+(BaseRequest *)getBuddhismHolidayBg:(RequestSuccessBlock)successBlock
                              failed:(RequestErrorBlock)errorBlock;
//用户添加亲友生日
+(BaseRequest *)addCalendarRemindDo:(NSInteger)mid
                          WithRname:(NSString *)rname
                              Rdate:(NSString *)rdate
                              Rtime:(NSInteger)rtime
                              Rtype:(NSInteger)type
                            success:(RequestSuccessBlock)successBlock
                             failed:(RequestErrorBlock)errorBlock;
//用户删除亲友生日
+(BaseRequest *)deleteCalendarRemindDo:(NSInteger)crid
                               success:(RequestSuccessBlock)successBlock
                                failed:(RequestErrorBlock)errorBlock;
//用户修改亲友生日
+(BaseRequest *)modifyCalendarRemindDo:(NSInteger)mid
                             WithRname:(NSString *)rname
                                 Rdate:(NSString *)rdate
                                 Rtime:(NSInteger)rtime
                                  Crid:(NSInteger)crid
                               success:(RequestSuccessBlock)successBlock
                                failed:(RequestErrorBlock)errorBlock;
//用户私有亲友生日提醒
+(BaseRequest *)getCalendarRemindList:(NSInteger)mid
                              success:(RequestSuccessBlock)successBlock
                               failed:(RequestErrorBlock)errorBlock;
@end
