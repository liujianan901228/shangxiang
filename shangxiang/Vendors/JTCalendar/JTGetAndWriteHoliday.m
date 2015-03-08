//
//  JTGetAndWriteHoliday.m
//  shangxiang
//
//  Created by 刘佳男 on 15/1/31.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "JTGetAndWriteHoliday.h"

@implementation JTGetAndWriteHoliday

- (void)saveHoliday:(NSString *)holidayStr
{
    NSString *month = [holidayStr substringToIndex:2];
    
    NSRange rang;
    rang.length = 2;
    rang.location = 2;
    NSString *day = [holidayStr substringWithRange:rang];
    
    rang.location = 5;
    rang.length = holidayStr.length-5;
    NSString *str = [holidayStr substringWithRange:rang];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:str forKey:[NSString stringWithFormat:@"%@%@",month,day]];
}

- (void)saveRemind:(NSArray *)remindArray
{
    
//    NSNumber *remindId = [dic objectForKey:@"id"];
//    NSString *relativesName = [dic objectForKey:@"relativesname"];
//    NSDate *remindDate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"reminddate"] integerValue]];
//    NSNumber *remindTime = [dic objectForKey:@"remindtime"];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:@"remindArray"];
    [def setObject:remindArray forKey:@"remindArray"];
}

- (void)getBuddhismHolidayList
{
    static BOOL first = YES;
    //    typeof(self) weakSelf = self;
    for (int i = 1; i <= 12; i++) {
        [CalendarDataSource getLunarFestival:i WithMid:0 success:^(id obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray *arr = (NSArray *)obj;
                if (arr.count >= 1) {
                    for (NSString *str in obj[0]) {
                        [self saveHoliday:str];
                    }
                }
                if ((arr.count >= 2) && first) {
                    [self saveRemind:obj[1]];
                    first = NO;
                }
            });
        } failed:^(id error) {
            //            [weakSelf removeAllHUDViews:YES];
            //            [weakSelf dealWithError:error];
            //            [weakSelf doneLoadMoreData];
            NSLog(@"sdfdsf");
        }];
    }
    
    
}

@end
