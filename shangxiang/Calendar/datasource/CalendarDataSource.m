//
//  CalendarDataSource.m
//  shangxiang
//
//  Created by 刘佳男 on 15/1/25.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "CalendarDataSource.h"
#import "OrderObject.h"

int endAction;

@implementation CalendarDataSource

//获取佛教节日
+(BaseRequest*)getLunarFestival:(NSInteger)month
                        WithMid:(NSInteger)mid
                     success:(RequestSuccessBlock)successBlock
                      failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if(month)
    {
        [params setObject:@(month) forKey:@"nl"];
    }
    if (USEROPERATIONHELP.currentUser.userId) {
        [params setObject:USEROPERATIONHELP.currentUser.userId forKey:@"mid"];
    }
    else{
        [params setObject:@"110001" forKey:@"mid"];
    }
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getbuddhismholidaylist.php" parameters:params CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            NSMutableArray* array = [[NSMutableArray alloc] init];
            NSArray* dicArray = [info objectForKey:@"buddhismholiday"];
            [array addObject:dicArray];
            dicArray = [info objectForKey:@"calendarlist"];
            [array addObject:dicArray];
            
            EXECUTE_BLOCK_SAFELY(successBlockCopy,array);
        }
    }];
    return request;
}
//用户私有求愿还愿
+(BaseRequest *)getOrderWishDateRemind:(int)mid
                              withDate:(NSString *)dateStr
                               success:(RequestSuccessBlock)successBlock
                                failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if (USEROPERATIONHELP.currentUser.userId) {
        [params setObject:USEROPERATIONHELP.currentUser.userId forKey:@"mid"];
    }
    if (dateStr) {
        [params setObject:dateStr forKey:@"date"];
    }
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getorderwishdateremindlist.php" parameters:params CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            
            NSString *code = [info objectForKey:@"code"];
            if ([code isEqualToString:@"succeed"]) {
                
                NSMutableArray* array = [[NSMutableArray alloc] init];
                NSArray* dicArray = [info objectForKey:@"orderwishdatelist"];
                for(NSDictionary* dictionary in dicArray)
                {
                    OrderObject* object = [[OrderObject alloc] initWithDic:dictionary];
                    [array addObject:object];
                }
                EXECUTE_BLOCK_SAFELY(successBlockCopy,array);
            }
            
            else
            {
                EXECUTE_BLOCK_SAFELY(successBlockCopy,nil);
            }
            

        }
    }];
    return request;
}

//用户私有亲友生日提醒
+(BaseRequest *)getCalendarRemindList:(NSInteger)mid
                               success:(RequestSuccessBlock)successBlock
                                failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if (USEROPERATIONHELP.currentUser.userId)
    {
        [params setObject:USEROPERATIONHELP.currentUser.userId forKey:@"mid"];
    }
    else
    {
        EXECUTE_BLOCK_SAFELY(successBlockCopy,nil);
        return nil;
    }
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getcalendarremindlist.php" parameters:params CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            
            NSString *code = [info objectForKey:@"code"];
            if ([code isEqualToString:@"succeed"]) {
                
                NSArray* dicArray = [info objectForKey:@"calendarlist"];
                EXECUTE_BLOCK_SAFELY(successBlockCopy,dicArray);
            }
            
            else
            {
                EXECUTE_BLOCK_SAFELY(successBlockCopy,nil);
            }
            
            
        }
    }];
    return request;
}

//用户添加亲友生日
+(BaseRequest *)addCalendarRemindDo:(NSInteger)mid
                          WithRname:(NSString *)rname
                              Rdate:(NSString *)rdate
                              Rtime:(NSInteger)rtime
                              Rtype:(NSInteger)type
                              success:(RequestSuccessBlock)successBlock
                               failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if (![rname isEqualToString:@""]) {
        [params setObject:rname forKey:@"rname"];
    }
    else
    {
        [self alertShow:@"请填写亲友姓名"];
        return nil;
    }
    
    
    if (rdate) {
        [params setObject:rdate forKey:@"rdate"];
    }
    
    if (USEROPERATIONHELP.currentUser.userId) {
        [params setObject:USEROPERATIONHELP.currentUser.userId forKey:@"mid"];
    }
    else{
        [params setObject:@"110001" forKey:@"mid"];
    }
    
    [params setObject:@(rtime) forKey:@"rtime"];
    [params setObject:@(type) forKey:@"type"];
    
    BaseRequest* request = [BaseRequest sendPostRequestWithMethod:@"addcalendarreminddo.php" parameters:params CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            EXECUTE_BLOCK_SAFELY(successBlockCopy,info);
        }
    }];
    return request;
}
//用户修改亲友生日
+(BaseRequest *)modifyCalendarRemindDo:(NSInteger)mid
                             WithRname:(NSString *)rname
                                 Rdate:(NSString *)rdate
                                 Rtime:(NSInteger)rtime
                                  Crid:(NSInteger)crid
                               success:(RequestSuccessBlock)successBlock
                                failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if (![rname isEqualToString:@""]) {
        [params setObject:rname forKey:@"rname"];
    }
    else
    {
        [self alertShow:@"请填写亲友姓名"];
        return nil;
    }
    
    
    if (rdate) {
        [params setObject:rdate forKey:@"rdate"];
    }
    
    if (USEROPERATIONHELP.currentUser.userId) {
        [params setObject:USEROPERATIONHELP.currentUser.userId forKey:@"mid"];
    }
    else{
        [params setObject:@"110001" forKey:@"mid"];
    }
    
    [params setObject:@(rtime) forKey:@"rtime"];
    
    if (crid) {
        [params setObject:@(crid) forKey:@"crid"];
    }
    
    BaseRequest* request = [BaseRequest sendPostRequestWithMethod:@"modifycalendarreminddo.php" parameters:params CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            EXECUTE_BLOCK_SAFELY(successBlockCopy,info);
        }
    }];
    return request;
}
//用户删除亲友生日提醒
+(BaseRequest *)deleteCalendarRemindDo:(NSInteger)crid
                              success:(RequestSuccessBlock)successBlock
                               failed:(RequestErrorBlock)errorBlock
{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    [params setObject:@(crid) forKey:@"crid"];
    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"deletecalendarreminddo.php" parameters:params CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            EXECUTE_BLOCK_SAFELY(successBlockCopy,info);
        }
    }];
    return request;
}
//获取佛历背景图片
+(BaseRequest *)getBuddhismHolidayBg:(RequestSuccessBlock)successBlock
                               failed:(RequestErrorBlock)errorBlock

{
    RequestSuccessBlock successBlockCopy = [successBlock copy];
    RequestErrorBlock errorBlockCopy = [errorBlock copy];
    

    
    BaseRequest* request = [BaseRequest sendGetRequestWithMethod:@"getbuddhismholidaybg.php" parameters:nil CompleteBlock:^(NSInteger errorNum, id info, ExError *errorMsg) {
        if(errorMsg)
        {
            EXECUTE_BLOCK_SAFELY(errorBlockCopy,errorMsg);
        }
        else
        {
            
            NSString *code = [info objectForKey:@"code"];
            if ([code isEqualToString:@"succeed"]) {
                
                NSString *str = [info objectForKey:@"folibg"];

                EXECUTE_BLOCK_SAFELY(successBlockCopy,str);
            }
            
            else
            {
                EXECUTE_BLOCK_SAFELY(successBlockCopy,nil);
            }
            
            
        }
    }];
    return request;
}

+ (void)alertShow:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [APPNAVGATOR.alertViewArray addObject:alert];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [APPNAVGATOR.alertViewArray removeObject:alertView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (endAction == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissEditMode" object:nil];
    }
}

@end
