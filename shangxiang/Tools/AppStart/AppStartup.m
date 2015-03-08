//
//  AppStartup.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "AppStartup.h"
#import "MyRequestManager.h"
#import "CalendarDataSource.h"

@interface AppStartup()<UIAlertViewDelegate>
@property(nonatomic,strong)UIAlertView* optionalAlertView;
@property(nonatomic,strong)UIAlertView* requireAlertView;
@property(nonatomic)BOOL hasShowForceAlert;
@end

@implementation AppStartup
+(AppStartup*)shareInstance
{
    static dispatch_once_t onceToken;
    static id sharedObject = nil;
    dispatch_once(&onceToken, ^{
        sharedObject = [[AppStartup alloc] init];
    });
    return sharedObject;
}


-(void)startUp
{
    USEROPERATIONHELP.currentUser = [UserGlobalSetting getCurrentUser];//获取全局用户信息
    
    //获取城市省份
    [MyRequestManager getProvinceCitys:^(id obj)
    {
        
    } failed:^(id error) {
        
    }];
    
    
    //获取日历背景图片
    [CalendarDataSource getBuddhismHolidayBg:^(id obj) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:obj forKey:@"foliBg"];
    } failed:^(id error) {
        
    }];
    
}



@end
